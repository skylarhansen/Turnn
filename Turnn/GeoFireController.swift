//
//  GeoFireController.swift
//  Turnn
//
//  Created by Jake Hardy on 4/15/16.
//  Copyright © 2016 Relief Group. All rights reserved.
//  Lended with love by Nathan Falcone on 8/8/16.
//  Adapted with gratitude by Team Turnn on 8/8/16.
//

import Foundation
import FirebaseDatabase
import GeoFire

class GeoFireController {
    
    static let geofire = GeoFire(firebaseRef: FirebaseController.ref.child("Locations"))
  
    static let eventDataPoint = FirebaseController.ref.child("Events")
    
    static func setLocation(eventID: String, location: CLLocation, completion: (success : Bool, savedLocation: FIRDatabaseReference?) -> Void) {
        let key = geofire.firebaseRef.childByAutoId().key
        geofire.setLocation(location, forKey: key) { (error) in
            if let error = error {
                print(error)
                completion(success: false, savedLocation: nil)
            }
            eventDataPoint.child(eventID).updateChildValues(["LocationID": key ])
            completion(success: true, savedLocation: geofire.firebaseRef.child(key))
        }
    }
    
    static func getEventIdsForLocationIdentifiers(ids: [String], completion: (ids: [String]?) -> Void) {
        var eventIDs: [String] = []
        let eventIDFetch = dispatch_group_create()
        for id in ids {
            dispatch_group_enter(eventIDFetch)
            FirebaseController.ref.child("Locations").child(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let locationDictionary = snapshot.value as? [String : AnyObject], eventID = locationDictionary["EventID"] as? String {
                    eventIDs.append(eventID)
                }
                dispatch_group_leave(eventIDFetch)
            })
        }
        dispatch_group_notify(eventIDFetch, dispatch_get_main_queue()) {
            completion(ids: eventIDs)
        }
    }
    
    static func getSingleEventIdForLocationIdentifier(id: String, completion: (id: String?) -> Void) {
        var eventIDtoExport: String = ""
        let singleEventIDFetch = dispatch_group_create()
            dispatch_group_enter(singleEventIDFetch)
            FirebaseController.ref.child("Locations").child(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let locationDictionary = snapshot.value as? [String : AnyObject], eventID = locationDictionary["EventID"] as? String {
                    eventIDtoExport = eventID
                }
                dispatch_group_leave(singleEventIDFetch)
            })
        dispatch_group_notify(singleEventIDFetch, dispatch_get_main_queue()) {
            completion(id: eventIDtoExport)
        }
    }
    
    static func getLocationIdsForEventIdentifiers(ids: [String], completion: (ids: [String]?) -> Void) {
        var locationIDs: [String] = []
        let locationIDFetch = dispatch_group_create()
        for id in ids {
            dispatch_group_enter(locationIDFetch)
            FirebaseController.ref.child("Events").child(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let locationDictionary = snapshot.value as? [String : AnyObject], locationID = locationDictionary["LocationID"] as? String {
                    locationIDs.append(locationID)
                }
                dispatch_group_leave(locationIDFetch)
            })
        }
        dispatch_group_notify(locationIDFetch, dispatch_get_main_queue()) {
            completion(ids: locationIDs)
        }
    }
    
    static func getSingleLocationIdForEventIdentifier(id: String, completion: (id: String?) -> Void) {
        var locationIDtoExport: String = ""
        let singleLocationIDFetch = dispatch_group_create()
        dispatch_group_enter(singleLocationIDFetch)
        FirebaseController.ref.child("Events").child(id).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let locationDictionary = snapshot.value as? [String : AnyObject], locationID = locationDictionary["LocationID"] as? String {
                locationIDtoExport = locationID
                }
                dispatch_group_leave(singleLocationIDFetch)
        })
        dispatch_group_notify(singleLocationIDFetch, dispatch_get_main_queue()) {
            completion(id: locationIDtoExport)
        }
    }
    
    // DEFINITIONS: OLDEVENTS are events whose "endTime" has passed,
    //              FUTUREEVENTS are vents whose "startTime" is more than 24 hours away from now
    //              CURRENTEVENTS are all other events, whose "endTime" not not passed
    //                            and whose "startTime" is equal to or less than 24 hours away from now
    
    static func queryEventsForRadius(miles radius: Double, completion: (currentEvents: [Event]?, oldEvents: [Event]?, matchingLocationKeys: [String]?, futureEvents: [Event]?) -> Void) {
        var matchedLocationKeysArray: [String] = []
        guard let center = LocationController.sharedInstance.coreLocationManager.location else {
            completion(currentEvents: nil, oldEvents: nil, matchingLocationKeys: nil, futureEvents: nil)
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
                            print("EVENT RETRIEVED: \(events)")
                            
                            let eventSortOldOrNot = events.divide({$0.endTime.timeIntervalSince1970 >= NSDate().timeIntervalSince1970})
                            
                            let notOldEvents = eventSortOldOrNot.slice
                            let oldEvents = eventSortOldOrNot.remainder
                            
                            let eventSortFutureOrPresent = notOldEvents.divide({$0.startTime.timeIntervalSince1970 <= NSDate().dateByAddingTimeInterval(86400).timeIntervalSince1970})
                                
                            let currentEvents = eventSortFutureOrPresent.slice
                            let futureEvents = eventSortFutureOrPresent.remainder
                            
                            completion(currentEvents: currentEvents, oldEvents: oldEvents, matchingLocationKeys: matchedLocationKeysArray, futureEvents: futureEvents)
                        } else {
                            print("Dang it!!!")
                            completion(currentEvents: nil, oldEvents: nil, matchingLocationKeys: nil, futureEvents: nil)
                        }
                    })
                } else {
                    print("Did not get back any eventIDs")
                    completion(currentEvents: nil, oldEvents: nil, matchingLocationKeys: nil, futureEvents: nil)
                }
            })
        }
    }
}
//      METHOD TO OBSERVE KEYS 'EXITING' SEARCH RADIUS -- probably nothing we'll implement anytime soon
//
//        circleQuery.observeEventType(.KeyExited, withBlock: { (key, location: CLLocation!) in
//            print("Key '\(key)' left the search area (or was deleted), previously being at location '\(location)'")
//            let removalIndex = locationMatchArray.indexOf(key)
//            locationMatchArray.removeAtIndex(removalIndex!)
//        })
