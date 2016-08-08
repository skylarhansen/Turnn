//
//  Location.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/1/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import MapKit

class Location: FirebaseType {
    
    private let addressKey = "address"
    private let cityKey = "city"
    private let stateKey = "state"
    private let zipKey = "zip"
    private let latitudeKey = "latitude"
    private let longitudeKey = "longitude"
    
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var latitude: Double
    var longitude: Double
    var region: MKCoordinateRegion
    var identifier: String?
    
    var endpoint: String {
        return "Locations"
    }
    
    var dictionaryCopy: [String:AnyObject] {
        return [addressKey:address, cityKey:city, stateKey:state, zipKey:zipCode, longitudeKey:longitude, latitudeKey: latitude]
    }
    
    init(address: String, city: String, state: String, zipCode: String, latitude: Double, longitude: Double) {
        
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
        self.region = MKCoordinateRegion()
        self.identifier = nil
    }
    
    required init?(dictionary: [String:AnyObject], identifier: String) {
        
        guard let address = dictionary[addressKey] as? String,
        city = dictionary[cityKey] as? String,
        state = dictionary[stateKey] as? String,
        zipCode = dictionary[zipKey] as? String,
        latitude = dictionary[latitudeKey] as? Double,
        longitude = dictionary[longitudeKey] as? Double
            
            else { return nil }
        
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
        self.region = MKCoordinateRegion()
    }
}
 
 
 
 
 
 
 
 