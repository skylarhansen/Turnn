//
//  Location.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/1/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import MapKit

class Location {
    
    fileprivate let addressKey = "address"
    fileprivate let cityKey = "city"
    fileprivate let stateKey = "state"
    fileprivate let zipKey = "zip"
    fileprivate let latitudeKey = "latitude"
    fileprivate let longitudeKey = "longitude"
    
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var latitude: Double?
    var longitude: Double?
    
    var endpoint: String {
        return "Locations"
    }
    
    var dictionaryCopy: [String: AnyObject] {
        var dictionary: [String : AnyObject] = [addressKey: address as AnyObject, cityKey: city as AnyObject, stateKey: state as AnyObject, zipKey: zipCode as AnyObject]
        
        if let latitude = self.latitude {
            dictionary.updateValue(latitude as AnyObject, forKey: latitudeKey)
        }
        
        if let longitude = self.longitude {
            dictionary.updateValue(longitude as AnyObject, forKey: longitudeKey)
        }
        
        return dictionary
    }
    
    init(address: String, city: String, state: String, zipCode: String, latitude: Double? = 0.0, longitude: Double? = 0.0) {
        
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
    
    }
    
    init?(dictionary: [String:AnyObject]) {
        
        guard let address = dictionary[addressKey] as? String,
        let city = dictionary[cityKey] as? String,
        let state = dictionary[stateKey] as? String,
        let zipCode = dictionary[zipKey] as? String,
        let latitude = dictionary[latitudeKey] as? Double,
        let longitude = dictionary[longitudeKey] as? Double
            
            else { return nil }
        
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
    }
}
 
 
 
 
 
 
 
 
