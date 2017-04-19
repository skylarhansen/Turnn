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
    
    var events: [Event] = []
    
    static let sharedController = EventController()
    
    static let eventData = FirebaseController.ref.child("Events")
    
    static func createEvent(_ title: String, location: Location, startTime: Date, endTime: Date, categories: [Int], eventDescription: String? = "", passwordProtected: Bool = false, password: String? = "", price: String? = "Free", contactInfo: String? = "", imageURL: String?, host: User, moreInfo: String?, completion: @escaping (_ success: Bool, _ eventID: String?) -> Void)
    {
        guard let host = UserController.shared.currentUser else { NSLog("there is no current user logged in"); return }
        
        var event = Event(title: title, location: location, startTime: startTime, endTime: endTime, categories: categories, eventDescription: eventDescription, passwordProtected: passwordProtected, password: password, price: price,contactInfo: contactInfo, imageURL: imageURL, host: host, moreInfo: moreInfo)
        
        event.save()
        
        if let eventID = event.identifier {
            LocationController.sharedInstance.forwardGeocoding(event) { (location, error) in
                print("\(String(describing: error?.description))")
                if let GPS = location {
                    GeoFireController.setLocation(eventID, location: GPS) { (success, savedLocation) in
                        savedLocation?.updateChildValues(["EventID" : eventID])
                        completion(true, eventID)
                    }
                } else {
                    completion(false, eventID)
                }
            }
        }
    }
    
    ////////////STEVE HERE IS THE DELETE EVENT FUNCTION SIGNATURE///////////////
    
    // // // // // // // // THANKS EVA YOU RAHRAHROCK!! // // // // // // // //
    
    static func getSingleEventIdForLocationIdentifier(_ id: String, completion: @escaping (_ id: String?) -> Void) {
        var eventIDtoExport: String = ""
        let singleEventIDFetch = DispatchGroup()
        singleEventIDFetch.enter()
        FirebaseController.ref.child("Locations").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let locationDictionary = snapshot.value as? [String : AnyObject], let eventID = locationDictionary["EventID"] as? String {
                eventIDtoExport = eventID
            }
            singleEventIDFetch.leave()
        })
        singleEventIDFetch.notify(queue: DispatchQueue.main) {
            completion(eventIDtoExport)
        }
    }
    
    func deleteEvent(_ event: Event){
        if let locationID = event.locationID {
            FirebaseController.ref.child("Locations").child(locationID).removeValue()
        }
        if let identifier = event.identifier {
            FirebaseController.ref.child("Users").child(UserController.shared.currentUserId).child("events").child(identifier).removeValue()
            event.delete()
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
    
    static func fetchEventsForUserID(_ uid: String, completion: @escaping (_ events: [Event]?) -> Void) {
        let users = FirebaseController.ref.child("Users")
        users.child(UserController.shared.currentUserId).child("events").observe(.value, with: { (snapshot) in
            if let eventDictionary = snapshot.value as? [String : AnyObject] {
                let eventIDs = eventDictionary.flatMap({ ($0.0) })
                fetchEventsThatMatchQuery(eventIDs, completion: { (events) in
                    completion(events)
                })
            } else {
                completion(nil)
            }
        })
    }
    
    // Gets particular events with identifiers -> Completes with [Event]
    static func fetchEventsThatMatchQuery(_ eventIDs: [String], completion: @escaping (_ events: [Event]?) -> Void) {
        var events: [Event] = []
        
        let eventFetchGroup = DispatchGroup()
        for eventID in eventIDs {
            eventFetchGroup.enter()
            eventData.child(eventID).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot.value!)
                if let eventDictionary = snapshot.value as? [String : AnyObject], let event = Event(dictionary: eventDictionary, identifier: eventID) {
                    events.append(event)
                }
                eventFetchGroup.leave()
            })
        }
        eventFetchGroup.notify(queue: DispatchQueue.main) {
            completion(events)
        }
    }
    
    static func updateEvent(_ event: Event){
        if let identifier = event.identifier {
            FirebaseController.ref.child("Events").child(identifier).updateChildValues(event.dictionaryCopy)
        } else {
            print("Event could not be updated. Event ID is \(event.identifier!)")
        }
    }
    
    static func filterEventsByCategories(_ events: [Event], categories: [Int]) -> [Event]? {
        let filteredEvents = NSMutableSet()
        for event in events {
            for eventCategory in event.categories {
                for category in categories {
                    if category == eventCategory {
                        filteredEvents.add(event)
                    }
                }
            }
        }
        return filteredEvents.allObjects as? [Event]
    }
    
    static func createSnapShotOfLocation(_ location: Location, completion: @escaping (_ success: Bool, _ image: UIImage?, _ location: CLLocation?) -> Void) {
        let address = String.autoformatAddressForGPSAquistionWith(location.address, city: location.city, state: location.state, zipCode: location.zipCode)
        
        LocationController.sharedInstance.forwardGeocoding(address) { (location, error) in
            let center = CLLocationCoordinate2DMake(location?.coordinate.latitude ?? 0.0, location?.coordinate.longitude ?? 0.0)
            let region = MKCoordinateRegionMakeWithDistance(center, 1.0.makeMeters(), 1.0.makeMeters())
            let options = MKMapSnapshotOptions()
            options.region = region
            options.scale = UIScreen.main.scale
            
            if location?.coordinate.latitude == nil || location?.coordinate.longitude == nil {
                completion(false, nil, location)
            } else {
                
                let snapshotter = MKMapSnapshotter(options: options)
                snapshotter.start (completionHandler: { snapshot, error in
                    guard let snapshot = snapshot else {
                        print("Snapshot error: \(String(describing: error))")
                        completion(false, nil, nil)
                        return
                    }
                    
                    let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                    let image = snapshot.image
                    
                    UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                    image.draw(at: CGPoint.zero)
                    
                    let visibleRect = CGRect(origin: CGPoint.zero, size: image.size)
                    var point = snapshot.point(for: location!.coordinate)
                    if visibleRect.contains(point) {
                        point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
                        point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
                        pin.image?.draw(at: point)
                    }
                    
                    let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    completion(true, compositeImage, nil)
                })
            }
        }
    }
}
