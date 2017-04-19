//
//  LocationController.swift
//  Turnn
//
//  Created by Steve Cox on 8/8/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import CoreLocation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
    func forwardGeocoding(_ event: Event, completion: @escaping (_ location: CLLocation?, _ error: String?) -> Void) {
        var coordinate: CLLocationCoordinate2D?
        var event = event
        let address = String.autoformatAddressForGPSAquisitionWith(event)
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
                completion(nil, "\(String(describing: error?.localizedDescription))")
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
                    completion(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), nil)
                } else {
                    completion(nil, "Could not unwrap a value for coordinate")
                }
            } else {
                completion(nil, "Placemark Count <= 0")
            }
        })
    }
    
    func forwardGeocoding(_ address: String, completion: @escaping (_ location: CLLocation?, _ error: String?) -> Void) {
        var coordinate: CLLocationCoordinate2D?
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
                completion(nil, "\(String(describing: error?.localizedDescription))")
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                coordinate = location?.coordinate
                //print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                if let coordinate = coordinate {
                    completion(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), nil)
                } else {
                    completion(nil, "Could not unwrap a value for coordinate")
                }
            } else {
                completion(nil, "Placemark Count <= 0")
            }
        })
    }
}
