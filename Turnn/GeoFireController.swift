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
    
    static func setLocation(_ eventID: String, location: CLLocation, completion: @escaping (_ success : Bool, _ savedLocation: DatabaseReference?) -> Void) {
        let key = geofire?.firebaseRef.childByAutoId().key
        geofire?.setLocation(location, forKey: key) { (error) in
            if let error = error {
                print(error)
                completion(false, nil)
            }
            eventDataPoint.child(eventID).updateChildValues(["LocationID": key! ])
            completion(true, geofire?.firebaseRef.child(key!))
        }
    }
    
    static func getEventIdsForLocationIdentifiers(_ ids: [String], completion: @escaping (_ ids: [String]?) -> Void) {
        var eventIDs: [String] = []
        let eventIDFetch = DispatchGroup()
        for id in ids {
            eventIDFetch.enter()
            FirebaseController.ref.child("Locations").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let locationDictionary = snapshot.value as? [String : AnyObject], let eventID = locationDictionary["EventID"] as? String {
                    eventIDs.append(eventID)
                }
                eventIDFetch.leave()
            })
        }
        eventIDFetch.notify(queue: DispatchQueue.main) {
            completion(eventIDs)
        }
    }
    
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
    
    static func getLocationIdsForEventIdentifiers(_ ids: [String], completion: @escaping (_ ids: [String]?) -> Void) {
        var locationIDs: [String] = []
        let locationIDFetch = DispatchGroup()
        for id in ids {
            locationIDFetch.enter()
            FirebaseController.ref.child("Events").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let locationDictionary = snapshot.value as? [String : AnyObject], let locationID = locationDictionary["LocationID"] as? String {
                    locationIDs.append(locationID)
                }
                locationIDFetch.leave()
            })
        }
        locationIDFetch.notify(queue: DispatchQueue.main) {
            completion(locationIDs)
        }
    }
    
    static func getSingleLocationIdForEventIdentifier(_ id: String, completion: @escaping (_ id: String?) -> Void) {
        var locationIDtoExport: String = ""
        let singleLocationIDFetch = DispatchGroup()
        singleLocationIDFetch.enter()
        FirebaseController.ref.child("Events").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let locationDictionary = snapshot.value as? [String : AnyObject], let locationID = locationDictionary["LocationID"] as? String {
                locationIDtoExport = locationID
                }
                singleLocationIDFetch.leave()
        })
        singleLocationIDFetch.notify(queue: DispatchQueue.main) {
            completion(locationIDtoExport)
        }
    }
    
    // DEFINITIONS: OLDEVENTS are events whose "endTime" has passed,
    //              FUTUREEVENTS are vents whose "startTime" is more than 24 hours away from now
    //              CURRENTEVENTS are all other events, whose "endTime" not not passed
    //                            and whose "startTime" is equal to or less than 24 hours away from now
    
    static func queryEventsForRadius(miles radius: Double, completion: @escaping (_ currentEvents: [Event]?, _ oldEvents: [Event]?, _ matchingLocationKeys: [String]?, _ futureEvents: [Event]?) -> Void) {
        var matchedLocationKeysArray: [String] = []
        guard let center = LocationController.sharedInstance.coreLocationManager.location else {
            completion(nil, nil, nil, nil)
            return }
        
        //print("My Location: \(center.coordinate.latitude), \(center.coordinate.longitude)")
        let circleQuery = geofire?.query(at: center, withRadius: radius.makeKilometers())
        circleQuery?.observe(.keyEntered, with: { (key, location) in
            //print("Key '\(key)' entered the search area and is at location '\(location)'")
            matchedLocationKeysArray.append(key!)
        })
        
        circleQuery?.observeReady{
            GeoFireController.getEventIdsForLocationIdentifiers(matchedLocationKeysArray, completion: { (ids) in
                if let ids = ids {
                    EventController.fetchEventsThatMatchQuery(ids, completion: { (events) in
                        // print(events)
                        if let events = events {
                            print("EVENT RETRIEVED: \(events)")
                            
                            let eventSortOldOrNot = events.divide({$0.endTime.timeIntervalSince1970 >= Date().timeIntervalSince1970})
                            
                            let notOldEvents = eventSortOldOrNot.slice
                            let oldEvents = eventSortOldOrNot.remainder
                            
                            let eventSortFutureOrPresent = notOldEvents.divide({$0.startTime.timeIntervalSince1970 <= Date().addingTimeInterval(86400).timeIntervalSince1970})
                                
                            let currentEvents = eventSortFutureOrPresent.slice
                            let futureEvents = eventSortFutureOrPresent.remainder
                            
                            completion(currentEvents, oldEvents, matchedLocationKeysArray, futureEvents)
                        } else {
                            print("Dang it!!!")
                            completion(nil, nil, nil, nil)
                        }
                    })
                } else {
                    print("Did not get back any eventIDs")
                    completion(nil, nil, nil, nil)
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
