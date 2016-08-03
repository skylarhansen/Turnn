//
//  EventController.swift
//  Turnn
//
//  Created by Steve Cox on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import UIKit

class EventController {

    static func createEvent(title: String, location: Location, startTime: NSDate, endTime: NSDate, categories: [Category], eventDescription: String? = "", passwordProtected: Bool? = false, password: String?, price: Double?, contactInfo: String?, image: UIImage?, moreInfo: String?)
    {
        guard let host = UserController.sharedController.currentUser
            else { NSLog("there is no current user logged in"); return }
        
        var event = Event(title: title, location: location, startTime: startTime, endTime: endTime, categories: categories, eventDescription: eventDescription, passwordProtected: passwordProtected, password: password, price: price,contactInfo: contactInfo, image: image, host: host, moreInfo: moreInfo)
        
        event.save()
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
    

}
