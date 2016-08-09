//
//  GeoFireController.swift
//  Turnn
//
//  Created by Jake Hardy on 4/15/16.
//  Copyright © 2016 Relief Group. All rights reserved.
//

import Foundation
import FirebaseDatabase
import GeoFire

class GeoFireController {
 
    static let geofire = GeoFire(firebaseRef: FirebaseController.ref.child("Locations"))
    
    static let eventData = FirebaseController.ref.child("Events")
    
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
    
    static func createLocation(address: String, city: String, state: String, zipCode: String, latitude: Double, longitude: Double)
    {
      //  var location = Location(address: address, city: city, state: state, zipCode: zipCode)
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