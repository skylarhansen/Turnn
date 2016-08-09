//
//  LocationController.swift
//  Turnn
//
//  Created by Dylan Slade on 4/14/16.
//  Copyright © 2016 Relief Group. All rights reserved.
//

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
    
    // Enter address to get GPS for Event
    func forwardGeocoding(address: String, completion: (location: CLLocation?, error: String?) -> Void) {
        var coordinate: CLLocationCoordinate2D?
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                completion(location: nil, error: "\(error?.localizedDescription)")
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                if let coordinate = coordinate {
                    completion(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), error: nil)
                } else {
                    completion(location: nil, error: "Could not unwrap a value for coordinate")
                }
            } else {
                completion(location: nil, error: "Placemark Count <= 0")
            }
        })
    }
}