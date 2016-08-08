//
//  GeoFireController.swift
//  Turnn
//
//  Created by Jake Hardy on 4/15/16.
//  Copyright © 2016 Relief Group. All rights reserved.
//

// SAMPLE CODE TO STUDY TO FIGURE OUT HOW TO DO OURS

// well, mostly sample code, Team Turnn has had to tweak several
// things, to adapt it to the recently released Firebase 3.0

import Foundation
import FirebaseDatabase
import GeoFire

class GeoFireController {
 
    static let geofire = GeoFire(firebaseRef: FirebaseController.ref)
    
    //static let geofire = GeoFire(firebaseRef: FirebaseController.firebase.childByAppendingPath("Location"))
    
    static func setLocation(eventID: String, location: CLLocation, completion: (success : Bool) -> Void) {
        geofire.setLocation(location, forKey: eventID) { (error) in
            if let error = error {
                print(error)
                completion(success: false)
            }
            completion(success: true)
        }
    }
    
    static func createLocation(address: String, city: String, state: String, zipCode: String, latitude: Double, longitude: Double)
    {
        var location = Location(address: address, city: city, state: state, zipCode: zipCode, latitude: latitude, longitude: longitude)
        location.save()
    }
    
    
    static func queryFiveMilesAroundMe() {
        guard let center = LocationController.sharedInstance.coreLocationManager.location else { return }
        let circleQuery = geofire.queryAtLocation(center, withRadius: 5.makeMeters())
        circleQuery.observeEventType(.KeyEntered) { (eventID, location) in
            //EventController.fetchfetchEventWithEventID(eventID, completion: { (event) in
                ///NSNotificationCenter.defaultCenter().postNotificationName("NewLocalEvent", object: nil)
      //  })
        }
        circleQuery.observeEventType(.KeyExited) { (eventID, location) in
            NSNotificationCenter.defaultCenter().postNotificationName("NewLocalEvent", object: nil)
        }
    }
}