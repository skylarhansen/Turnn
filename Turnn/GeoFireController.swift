//
//  GeoFireController.swift
//  Turnn
//
//  Created by Jake Hardy on 4/15/16.
//  Copyright © 2016 Relief Group. All rights reserved.
//  Lended with Love by Nathan Falcone on 8/8/16.
//  Adapted with gratitude by Team Turnn on 8/8/16.
//

import Foundation
import FirebaseDatabase
import GeoFire

class GeoFireController {
    
    static let geofire = GeoFire(firebaseRef: FirebaseController.ref.child("Locations"))
    
    static func setLocation(eventID: String, location: CLLocation, completion: (success : Bool, savedLocation: FIRDatabaseReference?) -> Void) {
        let key = geofire.firebaseRef.childByAutoId().key
        geofire.setLocation(location, forKey: key) { (error) in
            if let error = error {
                print(error)
                completion(success: false, savedLocation: nil)
            }
            completion(success: true, savedLocation: geofire.firebaseRef.child(key))
        }
    }
    
    static func getEventIdsForLocationIdentifiers(ids: [String], completion: (ids: [String]?) -> Void) {
        var eventIDs: [String] = []
        
        let eventIDFetch = dispatch_group_create()
        for id in ids {
            dispatch_group_enter(eventIDFetch)
            FirebaseController.ref.child("Locations").child(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                print(snapshot.value!)
                if let locationDictionary = snapshot.value as? [String : AnyObject], eventID = locationDictionary["EventID"] as? String {
                    eventIDs.append(eventID)
                    dispatch_group_leave(eventIDFetch)
                }
            })
        }
        
        dispatch_group_notify(eventIDFetch, dispatch_get_main_queue()) { 
            completion(ids: eventIDs)
        }
    }
    
    static func queryEventsForRadius(miles radius: Double, completion: (currentEvents: [Event]?, oldEvents: [Event]?) -> Void) {
        var matchedLocationKeysArray: [String] = []
        guard let center = LocationController.sharedInstance.coreLocationManager.location else {
            completion(currentEvents: nil, oldEvents: nil)
            return }
        
        //print("My Location: \(center.coordinate.latitude), \(center.coordinate.longitude)")
        let circleQuery = geofire.queryAtLocation(center, withRadius: radius.makeKilometers())
        circleQuery.observeEventType(.KeyEntered, withBlock: { (key, location) in
            //print("Key '\(key)' entered the search area and is at location '\(location)'")
            matchedLocationKeysArray.append(key)
            
        })
        
        circleQuery.observeReadyWithBlock{
            GeoFireController.getEventIdsForLocationIdentifiers(matchedLocationKeysArray, completion: { (ids) in
                if let ids = ids {
                    EventController.fetchEventsThatMatchQuery(ids, completion: { (events) in
                        // print(events)
                        if let events = events {
                            //print("EVENT RETRIEVED: \(events)")
                            
                            let eventSort = events.divide({$0.endTime.timeIntervalSince1970 >= NSDate().timeIntervalSince1970})
                            
                            let currentEvents = eventSort.slice
                            let oldEvents = eventSort.remainder
                            
                            completion(currentEvents: currentEvents, oldEvents: oldEvents)
                        } else {
                            print("Dang it!!!")
                            completion(currentEvents: nil, oldEvents: nil)
                        }
                    })
                } else {
                    print("Did not get back any eventIDs")
                    completion(currentEvents: nil, oldEvents: nil)
                }
            })
        }
    }
}

//        circleQuery.observeEventType(.KeyExited, withBlock: { (key, location: CLLocation!) in
//            print("Key '\(key)' left the search area (or was deleted), previously being at location '\(location)'")
//            let removalIndex = locationMatchArray.indexOf(key)
//            locationMatchArray.removeAtIndex(removalIndex!)
//        })
