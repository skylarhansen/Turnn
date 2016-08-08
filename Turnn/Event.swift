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
    
    private let titleKey = "title"
    private let locationKey = "location"
    private let startTimeKey = "startTime"
    private let endTimeKey = "endTime"
    private let categoriesKey = "categories"
    private let eventDescriptionKey = "eventDescription"
    private let passwordProtectedKey = "passwordProtected"
    private let passwordKey = "password"
    private let priceKey = "price"
    private let contactInfoKey = "contactInfo"
    private let imageKey = "image"
    private let moreInfoKey = "moreInfo"
    private let hostKey = "host"
    private let identiferKey = "eventID"
    
    var title: String
    var location: Location
    var startTime: NSDate
    var endTime: NSDate
    var categories: [Int]
    var eventDescription: String?
    var passwordProtected: Bool
    var password: String?
    var price: Double?
    var contactInfo: String?
    var image: UIImage?
    var identifier: String?
    var host: User
    var moreInfo: String?
    
    var endpoint: String {
        return "Events"
    }
    
    var dictionaryCopy: [String: AnyObject] {

        var dictionary: [String : AnyObject] = [titleKey : title, startTimeKey : startTime.timeIntervalSince1970, endTimeKey : endTime.timeIntervalSince1970, categoriesKey : categories, hostKey: host.dictionaryCopy, locationKey : location.dictionaryCopy, passwordProtectedKey : passwordProtected]
        
        if let eventDescription = eventDescription {
            dictionary.updateValue(eventDescription, forKey: eventDescriptionKey)
        }
        
        if passwordProtected == true {
            if let password = password {
                dictionary.updateValue(password, forKey: passwordKey)
            }
        }
        
        if let price = price {
            dictionary.updateValue(price, forKey: priceKey)
        }

        if let contactInfo = contactInfo {
            dictionary.updateValue(contactInfo, forKey: contactInfoKey)
        }
        
        if let image = image {
            dictionary.updateValue(image, forKey: imageKey)
        }
        
        if let moreInfo = moreInfo {
            dictionary.updateValue(moreInfo, forKey: moreInfoKey)
        }

        return dictionary
    }
    
    init(title: String, location: Location, startTime: NSDate, endTime: NSDate, categories: [Int], eventDescription: String?, passwordProtected: Bool, password: String?, price: Double?, contactInfo: String?, image: UIImage?, host: User, moreInfo: String?) {
        
        self.title = title
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.categories = categories
        self.eventDescription = eventDescription
        self.passwordProtected = passwordProtected
        self.password = password
        self.price = price
        self.contactInfo = contactInfo
        self.image = image
        self.host = host
        self.moreInfo = moreInfo
        self.identifier = nil
    }
    
    required init?(dictionary: [String : AnyObject], identifier: String) {
        
        guard let title = dictionary[titleKey] as? String,
        locationDictionary = dictionary[locationKey] as? [String: AnyObject],
        location = Location(dictionary: locationDictionary),
            startTime = dictionary[startTimeKey] as? Double,
            endTime = dictionary[endTimeKey] as? Double,
            categories = dictionary[categoriesKey] as? [Int],
            eventDescription = dictionary[eventDescriptionKey] as? String,
            passwordProtected = dictionary[passwordProtectedKey] as? Bool,
            password = dictionary[passwordKey] as? String,
            price = dictionary[priceKey] as? Double,
            contactInfo = dictionary[contactInfoKey] as? String,
            image = dictionary[imageKey] as? UIImage,
        hostDictionary = dictionary[hostKey] as? [String : AnyObject],
            host = User(dictionary: hostDictionary, identifier: hostDictionary["id"] as! String),
            moreInfo = dictionary[moreInfoKey] as? String else { return nil }
        
        self.title = title
        self.location = location
        self.startTime = NSDate(timeIntervalSince1970: startTime)
        self.endTime = NSDate(timeIntervalSince1970: endTime)
        self.categories = categories
        self.eventDescription = eventDescription
        self.passwordProtected = passwordProtected
        self.password = password
        self.price = price
        self.contactInfo = contactInfo
        self.image = image
        self.host = host
        self.moreInfo = moreInfo
    }
}
