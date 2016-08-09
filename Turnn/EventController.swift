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

    static func createEvent(title: String, location: Location, startTime: NSDate, endTime: NSDate, categories: [Int], eventDescription: String?, passwordProtected: Bool = false, password: String?, price: Double?, contactInfo: String?, image: UIImage?, host: User, moreInfo: String?)
    {
        //guard let host = UserController.sharedController.currentUser
           // else { NSLog("there is no current user logged in"); return }
        
        var event = Event(title: title, location: location, startTime: startTime, endTime: endTime, categories: categories, eventDescription: eventDescription, passwordProtected: passwordProtected, password: password, price: price,contactInfo: contactInfo, image: image, host: host, moreInfo: moreInfo)
        
        event.save()
        
        LocationController.sharedInstance.forwardGeocoding(String.autoformatAddressForGPSAquisition(event)) { (location, error) in
            if let GPS = location {
                GeoFireController.setLocation(event.identifier!, location: GPS) { (success, savedLocation) in
                    savedLocation?.updateChildValues(["EventID" : event.identifier!])
                }
            }
        }
    }
    
    static func fetchEvents(completion: (events: [Event]) -> Void){
        FirebaseController.ref.child("Events").observeEventType(.Value, withBlock: { (dataSnapshot) in
            guard let dataDictionary = dataSnapshot.value as? [String: [String: AnyObject]] else {
                completion(events: [])
                return
            }
            let events = dataDictionary.flatMap { Event(dictionary: $1, identifier: $0) }
            completion(events: events)
        })
    }
    
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
