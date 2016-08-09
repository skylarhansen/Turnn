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
    
    static func queryFiveMilesAroundMe() {
        guard let center = LocationController.sharedInstance.coreLocationManager.location else { return }
        print("My Location: \(center.coordinate.latitude), \(center.coordinate.longitude)")
        let circleQuery = geofire.queryAtLocation(center, withRadius: 5.0.makeKilometers())
        circleQuery.observeEventType(.KeyEntered, withBlock: { (key, location: CLLocation!) in
                print("Key '\(key)' entered the search area and is at location '\(location)'")
            })

        circleQuery.observeEventType(.KeyExited, withBlock: { (key, location: CLLocation!) in
            print("Key '\(key)' left the search area, previously being at location '\(location)'")
        })
        
    }
}