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
    
    var title: String
    var location: Location
    var startTime: NSDate
    var endTime: NSDate
    var categories: [Categories]
    var eventDescription: String?
    var passwordProtected: Bool?
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
        
        guard let eventDescription = eventDescription,
            passwordProtected = passwordProtected,
            password = password,
            price = price,
            contactInfo = contactInfo,
            image = image,
            moreInfo = moreInfo else { return self.dictionaryCopy }
        
        var dictionary: [String : AnyObject] = [eventDescriptionKey: eventDescription, passwordProtectedKey: passwordProtected, passwordKey: password, priceKey: price, contactInfoKey: contactInfo, imageKey: image, moreInfoKey: moreInfo]
        
        dictionary.updateValue(eventDescription, forKey: eventDescriptionKey)
        dictionary.updateValue(passwordProtected, forKey: passwordProtectedKey)
        dictionary.updateValue(password, forKey: passwordKey)
        dictionary.updateValue(contactInfo, forKey: contactInfoKey)
        dictionary.updateValue(image, forKey: imageKey)
        dictionary.updateValue(moreInfo, forKey: moreInfoKey)
        dictionary.updateValue(price, forKey: priceKey)
        
        return dictionary
    }
    
    init(title: String, location: Location, startTime: NSDate, endTime: NSDate, categories: [Categories], eventDescription: String?, passwordProtected: Bool?, password: String?, price: Double?, contactInfo: String?, image: UIImage?, host: User, moreInfo: String?) {
        
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
            location = dictionary[locationKey] as? Location,
            startTime = dictionary[startTimeKey] as? NSDate,
            endTime = dictionary[endTimeKey] as? NSDate,
            categories = dictionary[categoriesKey] as? [Categories],
            eventDescription = dictionary[eventDescriptionKey] as? String,
            passwordProtected = dictionary[passwordProtectedKey] as? Bool,
            password = dictionary[passwordKey] as? String,
            price = dictionary[priceKey] as? Double,
            contactInfo = dictionary[contactInfoKey] as? String,
            image = dictionary[imageKey] as? UIImage,
            host = dictionary[hostKey] as? User,
            moreInfo = dictionary[moreInfoKey] as? String else { return nil }
        
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
    }
}
