//
//  EventController.swift
//  Turnn
//
//  Created by Steve Cox on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class EventController {
    
    static let eventData = FirebaseController.ref.child("Events")

    static func createEvent(title: String, location: Location, startTime: NSDate, endTime: NSDate, categories: [Int], eventDescription: String? = "", passwordProtected: Bool = false, password: String? = "", price: Double? = 0.0, contactInfo: String? = "", image: UIImage?, host: User, moreInfo: String?, completion: (success: Bool) -> Void)
    {
        //guard let host = UserController.sharedController.currentUser
           // else { NSLog("there is no current user logged in"); return }
        
        var event = Event(title: title, location: location, startTime: startTime, endTime: endTime, categories: categories, eventDescription: eventDescription, passwordProtected: passwordProtected, password: password, price: price,contactInfo: contactInfo, image: image, host: host, moreInfo: moreInfo)
        
        event.save()
        
        LocationController.sharedInstance.forwardGeocoding(String.autoformatAddressForGPSAquisition(event)) { (location, error) in
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
    
    static func fetchEvents(completion: (events: [Event]) -> Void){
        eventData.observeEventType(.Value, withBlock: { (dataSnapshot) in
            guard let dataDictionary = dataSnapshot.value as? [String: [String: AnyObject]] else {
                completion(events: [])
                return
            }
            let events = dataDictionary.flatMap { Event(dictionary: $1, identifier: $0) }
            completion(events: events)
        })
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
        // grabs data at specified endpoint and initializes (attempts) an Event object
       // FirebaseController.dataAtEndPoint(endpoint) { (data) in
        //    guard let json = data as? [String : AnyObject] else { completion(event: nil) ; return }
         //   guard let event = Event(dictionary: json, identifier: eventID) else //{ completion(event: nil) ; return }
         //   self.events.append(event)
            // Complete with initialized event
         //   completion(event: event)
        //}
    
    static func deleteEvent(event: Event){
        event.delete()
    }
    
    static func updateEvent(event: Event){
        if let identifier = event.identifier {
            FirebaseController.ref.child("Events").child(identifier).updateChildValues(event.dictionaryCopy)
        } else {
            print("Event could not be updated. Event ID is \(event.identifier!)")
        }
    }
    
    static func mockEvents() -> [Event]{
        
        let mockLocation = Location(address: "435 Gnarly Rd", city: "TinsleTown", state: "OR", zipCode: "84312")
        let mockUser = User(firstName: "Bob", lastName: "Dylan", identifier: "3456-abcd")
        
        let event1 = Event(title: "Hey! 1", location: mockLocation, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: [0,4,3,8], eventDescription: "Nice Event Man! 1", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: mockUser, moreInfo: nil)
        let event2 = Event(title: "Hey! 2", location: mockLocation, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: [0,2,1,5], eventDescription: "Nice Event Man! 2", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: mockUser, moreInfo: nil)
        let event3 = Event(title: "Hey! 3", location: mockLocation, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: [3,6,8], eventDescription: "Nice Event Man! 3", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: mockUser, moreInfo: nil)
        let event4 = Event(title: "Hey! 4", location: mockLocation, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: [2,9], eventDescription: "Nice Event Man! 4", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: mockUser, moreInfo: nil)
        
        return [event1, event2, event3, event4]
    }
}
