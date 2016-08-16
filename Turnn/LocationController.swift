//
//  LocationController.swift
//  Turnn
//
//  Created by Steve Cox on 8/8/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
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
    func forwardGeocoding(event: Event, completion: (location: CLLocation?, error: String?) -> Void) {
        var coordinate: CLLocationCoordinate2D?
        var event = event
        let address = String.autoformatAddressForGPSAquisitionWith(event)
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                completion(location: nil, error: "\(error?.localizedDescription)")
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                coordinate = location?.coordinate
                //print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                if let coordinate = coordinate {
                    event.location.latitude = coordinate.latitude
                    event.location.longitude = coordinate.longitude
                    event.save()
                    completion(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), error: nil)
                } else {
                    completion(location: nil, error: "Could not unwrap a value for coordinate")
                }
            } else {
                completion(location: nil, error: "Placemark Count <= 0")
            }
        })
    }
    
    func forwardGeocoding(address: String, completion: (location: CLLocation?, error: String?) -> Void) {
        var coordinate: CLLocationCoordinate2D?
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription)
                completion(location: nil, error: "\(error?.localizedDescription)")
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                coordinate = location?.coordinate
                //print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
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