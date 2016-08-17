//
//  EventController.swift
//  Turnn
//
//  Created by Steve Cox on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class EventController {
    
    static let eventData = FirebaseController.ref.child("Events")

    static func createEvent(title: String, location: Location, startTime: NSDate, endTime: NSDate, categories: [Int], eventDescription: String? = "", passwordProtected: Bool = false, password: String? = "", price: Double? = 0.0, contactInfo: String? = "", image: UIImage?, host: User, moreInfo: String?, completion: (success: Bool) -> Void)
    {
        guard let host = UserController.shared.currentUser else { NSLog("there is no current user logged in"); return }
        
        var event = Event(title: title, location: location, startTime: startTime, endTime: endTime, categories: categories, eventDescription: eventDescription, passwordProtected: passwordProtected, password: password, price: price,contactInfo: contactInfo, image: image, host: host, moreInfo: moreInfo)
        
        event.save()
        
        LocationController.sharedInstance.forwardGeocoding(event) { (location, error) in
            print(error)
            if let GPS = location {
                GeoFireController.setLocation(event.identifier!, location: GPS) { (success, savedLocation) in
                    savedLocation?.updateChildValues(["EventID" : event.identifier!])
                    completion(success: true)
                }
            } else {
                completion(success: false)
            }
        }
    }
    
//      NOT NECESSARY LONG-TERM, IS A WAY TO CONSTANTLY OBSERVE ALL EVENTS, REGARDLESS OF LOCATION.
//          may be helpful for testing events without having to be crazy particular about radius
//
//    static func fetchEvents(completion: (events: [Event]) -> Void){
//        eventData.observeEventType(.Value, withBlock: { (dataSnapshot) in
//            guard let dataDictionary = dataSnapshot.value as? [String: [String: AnyObject]] else {
//                completion(events: [])
//                return
//            }
//            let events = dataDictionary.flatMap { Event(dictionary: $1, identifier: $0) }
//            completion(events: events)
//        })
//    }
    
    static func filterEventsByCategories(events: [Event], categories: [Int]) -> [Event]? {
        let filteredEvents = NSMutableSet()
        for event in events {
            for eventCategory in event.categories {
                for category in categories {
                    if category == eventCategory {
                        filteredEvents.addObject(event)
                    }
                }
            }
        }
        
        return filteredEvents.allObjects as? [Event]
    }
    
    // Gets particular events with identifiers -> Completes with [Event]
    static func fetchEventsThatMatchQuery(eventIDs: [String], completion: (events: [Event]?) -> Void) {
        var events: [Event] = []
        
        let eventFetchGroup = dispatch_group_create()
        for eventID in eventIDs {
            dispatch_group_enter(eventFetchGroup)
            eventData.child(eventID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                print(snapshot.value!)
                if let eventDictionary = snapshot.value as? [String : AnyObject], let event = Event(dictionary: eventDictionary, identifier: eventID) {
                    events.append(event)
                    dispatch_group_leave(eventFetchGroup)
                }
            })
        }
        dispatch_group_notify(eventFetchGroup, dispatch_get_main_queue()) { 
            completion(events: events)
        }
    }
    
    static func deleteEvent(event: Event){
        if let identifier = event.identifier {
            FirebaseController.ref.child("Events").child(identifier).removeValue()
        }
        event.delete()
    }
    
    static func updateEvent(event: Event){
        if let identifier = event.identifier {
            FirebaseController.ref.child("Events").child(identifier).updateChildValues(event.dictionaryCopy)
        } else {
            print("Event could not be updated. Event ID is \(event.identifier!)")
        }
    }
    
    static func createSnapShotOfLocation(location: Location, completion: (success: Bool, image: UIImage?) -> Void) {
        let address = String.autoformatAddressForGPSAquistionWith(location.address, city: location.city, state: location.state, zipCode: location.zipCode)
        LocationController.sharedInstance.forwardGeocoding(address) { (location, error) in
            let center = CLLocationCoordinate2DMake(location?.coordinate.latitude ?? 0.0, location?.coordinate.longitude ?? 0.0)
            let region = MKCoordinateRegionMakeWithDistance(center, 1.0.makeMeters(), 1.0.makeMeters())
            let options = MKMapSnapshotOptions()
            options.region = region
            options.scale = UIScreen.mainScreen().scale
            
            
            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.startWithCompletionHandler { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Snapshot error: \(error)")
                    completion(success: false, image: nil)
                    return
                }
                
                let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                let image = snapshot.image
                
                UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                image.drawAtPoint(CGPoint.zero)
                
                let visibleRect = CGRect(origin: CGPoint.zero, size: image.size)
                var point = snapshot.pointForCoordinate(location!.coordinate)
                if visibleRect.contains(point) {
                    point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
                    point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
                    pin.image?.drawAtPoint(point)
                }
                
                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                completion(success: true, image: compositeImage)
            }
            
        }
    }
    
    static func mockEvents() -> [Event]{
        
        let mockLocation1 = Location(address: "435 Gnarly Rd", city: "TinsleTown", state: "OR", zipCode: "84312", latitude: 40.761819, longitude: -111.890561)
        
        let mockLocation2 = Location(address: "435 Gnarly Rd", city: "TinsleTown", state: "OR", zipCode: "84312", latitude: 40.762524, longitude: -111.890593)
        
        let mockLocation3 = Location(address: "435 Gnarly Rd", city: "TinsleTown", state: "OR", zipCode: "84312", latitude: 40.762503, longitude: -111.891835)
        
        let mockLocation4 = Location(address: "435 Gnarly Rd", city: "TinsleTown", state: "OR", zipCode: "84312", latitude: 40.762592, longitude: -111.889587)
        
        let mockUser = User(firstName: "Bob", lastName: "Dylan", identifier: "3456-abcd")
        
        let event1 = Event(title: "There's an event that's a 1", location: mockLocation1, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: [0,4,3,8], eventDescription: "I'm testing to see what this will look like if I put a really long string into the box so here goes: Tim Duncan, Tony Parker, Manu Ginobili, Kawhi Leonard, Gregg Popovich 1", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: mockUser, moreInfo: nil)
        
        let event2 = Event(title: "Hey! 2", location: mockLocation2, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: [0,2,1,5], eventDescription: "Nice Event Man! 2", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: mockUser, moreInfo: nil)
        
        let event3 = Event(title: "Hey! 3", location: mockLocation3, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: [3,6,8], eventDescription: "Nice Event Man! 3", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: mockUser, moreInfo: nil)
        
        let event4 = Event(title: "Hey! 4", location: mockLocation4, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: [2,9], eventDescription: "Nice Event Man! 4", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: mockUser, moreInfo: nil)
        
        return [event1, event2, event3, event4]
    }
}