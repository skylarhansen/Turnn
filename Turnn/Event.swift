//
//  Event.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/1/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import UIKit

class Event: FirebaseType {
    
    fileprivate let titleKey = "title"
    fileprivate let locationKey = "location"
    fileprivate let startTimeKey = "startTime"
    fileprivate let endTimeKey = "endTime"
    fileprivate let categoriesKey = "categories"
    fileprivate let eventDescriptionKey = "eventDescription"
    fileprivate let passwordProtectedKey = "passwordProtected"
    fileprivate let passwordKey = "password"
    fileprivate let priceKey = "price"
    fileprivate let contactInfoKey = "contactInfo"
    fileprivate let imageKey = "image"
    fileprivate let moreInfoKey = "moreInfo"
    fileprivate let hostKey = "host"
    fileprivate let identiferKey = "eventID"
    fileprivate let locationIDKey = "LocationID"
    
    var title: String
    var location: Location
    var startTime: Date
    var endTime: Date
    var categories: [Int]
    var eventDescription: String?
    var passwordProtected: Bool
    var password: String?
    var price: String?
    var contactInfo: String?
    var imageURL: String?
    var identifier: String?
    var host: User
    var moreInfo: String?
    var locationID: String?
    
    var endpoint: String {
        return "Events"
    }
    
    var dictionaryCopy: [String: AnyObject] {
        var dictionary: [String : AnyObject] = [titleKey : title as AnyObject, startTimeKey : startTime.timeIntervalSince1970 as AnyObject, endTimeKey : endTime.timeIntervalSince1970 as AnyObject, categoriesKey : categories as AnyObject, hostKey: host.dictionaryCopy as AnyObject, locationKey : location.dictionaryCopy as AnyObject, passwordProtectedKey : passwordProtected as AnyObject]
        
        if let eventDescription = eventDescription {
            dictionary.updateValue(eventDescription as AnyObject, forKey: eventDescriptionKey)
        }
        
        if passwordProtected == true {
            if let password = password {
                dictionary.updateValue(password as AnyObject, forKey: passwordKey)
            }
        }
        
        if let price = price {
            dictionary.updateValue(price as AnyObject, forKey: priceKey)
        }
        if let contactInfo = contactInfo {
            dictionary.updateValue(contactInfo as AnyObject, forKey: contactInfoKey)
        }
        
        if let image = imageURL {
            dictionary.updateValue(image as AnyObject, forKey: imageKey)
        }
        
        if let moreInfo = moreInfo {
            dictionary.updateValue(moreInfo as AnyObject, forKey: moreInfoKey)
        }
        return dictionary
    }
    
    init(title: String, location: Location, startTime: Date, endTime: Date, categories: [Int], eventDescription: String?, passwordProtected: Bool, password: String?, price: String?, contactInfo: String?, imageURL: String?, host: User, moreInfo: String?) {
        
        self.title = title
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.categories = categories
        self.eventDescription = eventDescription
        self.passwordProtected = passwordProtected
        self.password = password
        self.price = price
        self.imageURL = imageURL
        self.contactInfo = contactInfo
        self.host = host
        self.moreInfo = moreInfo
        self.identifier = nil
        self.locationID = nil
    }
    
    required init?(dictionary: [String : AnyObject], identifier: String) {
        
        guard let title = dictionary[titleKey] as? String,
            let locationDictionary = dictionary[locationKey] as? [String: AnyObject],
            let location = Location(dictionary: locationDictionary),
            let startTime = dictionary[startTimeKey] as? Double,
            let endTime = dictionary[endTimeKey] as? Double,
            let categories = dictionary[categoriesKey] as? [Int],
            let passwordProtected = dictionary[passwordProtectedKey] as? Bool,
            let locationID = dictionary[locationIDKey] as? String,
            let hostDictionary = dictionary[hostKey] as? [String : AnyObject],
            //Change back to id if and when we make that change
            let host = User(dictionary: hostDictionary, identifier: hostDictionary["firstName"] as? String ?? "") else {
                print("COULD NOT CONVERT DICTIONARY TO EVENT")
                return nil
        }
        
        if let locationID = dictionary[locationIDKey] as? String{
            self.locationID = locationID
        }
        
        if let eventDescription = dictionary[eventDescriptionKey] as? String {
            self.eventDescription = eventDescription
        }
        
        if passwordProtected == true {
            if let password = dictionary[passwordKey] as? String {
                self.password = password
            }
        }
        
        if let price = dictionary[priceKey] as? String {
            self.price = price
        }
        if let contactInfo = dictionary[contactInfoKey] as? String {
            self.contactInfo = contactInfo
        }
        
        if let image = dictionary[imageKey] as? String {
            self.imageURL = image
        }
        
        if let moreInfo = dictionary[moreInfoKey] as? String {
            self.moreInfo = moreInfo
        }
        
        self.title = title
        self.location = location
        self.startTime = Date(timeIntervalSince1970: startTime)
        self.endTime = Date(timeIntervalSince1970: endTime)
        self.categories = categories
        self.passwordProtected = passwordProtected
        self.host = host
        self.identifier = identifier
        self.locationID = locationID
    }
}
