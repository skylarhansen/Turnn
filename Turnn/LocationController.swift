//
//  LocationController.swift
//  Turnn
//
//  Created by Dylan Slade on 4/14/16.
//  Copyright © 2016 Relief Group. All rights reserved.
//

// SAMPLE CODE TO STUDY TO FIGURE OUT HOW TO DO OURS

import Foundation
import CoreLocation

class LocationController {
    static let sharedInstance = LocationController()
    var coreLocationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    
    // MARK: - Core Location
    func setUpCoreLocation() {
        self.coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest // use the highest level of accuracy
        self.coreLocationManager.requestWhenInUseAuthorization()
        self.coreLocationManager.startUpdatingLocation()
    }
    
    init() {
        setUpCoreLocation()
    }
    
    // Enter address to get Location for Event
    func getCoordinatesFromCity(address: String, completion: (longitude: CLLocationDegrees?, latitude: CLLocationDegrees?) -> Void ) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription)
                completion(longitude: nil, latitude: nil)
            } else {
                if let placemarks = placemarks, firstPlacemark = placemarks.first, location = firstPlacemark.location {
                    completion(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
                } else {
                    completion(longitude: nil, latitude: nil)
                }
            }
        }
    }
}