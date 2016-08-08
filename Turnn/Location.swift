//
//  Location.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/1/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import Mapbox

class Location {
    
    private let addressKey = "address"
    private let cityKey = "city"
    private let stateKey = "state"
    private let zipKey = "zip"
    
    
    var address: String
    var city: String
    var state: String
    var zipCode: String
//    var latitude: Double {}
//    var longitude: Double {}
    //var region: MKCoordinateRegion
    
    var endpoint: String {
        
        return "Locations"
    }
    
    var dictionaryCopy: [String:AnyObject] {
        return [addressKey:address, cityKey:city, stateKey:state, zipKey:zipCode]
    }
    
    init(address: String, city: String, state: String, zipCode: String) {
        
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
       // self.region = MKCoordinateRegion()
    }
    
    init?(dictionary: [String:AnyObject]) {
        
        guard let address = dictionary[addressKey] as? String,
        city = dictionary[cityKey] as? String,
        state = dictionary[stateKey] as? String,
        zipCode = dictionary[zipKey] as? String else { return  nil }
        
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        //self.region = MKCoordinateRegion()
    }
}
 
 
 
 
 
 
 
 