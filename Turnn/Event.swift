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
    private let descriptionKey = "description"
    private let passwordProtectedKey = "passwordProtected"
    private let passwordKey = "password"
    private let contactInfoKey = "contactInfo"
    private let imageKey = "image"
    private let moreInfoKey = "moreInfo"
    private let hostKey = "host"
    
    var title: String
    var location: Location
    var startTime: NSDate
    var endTime: NSDate
//        var categories: [Category]
    var description: String?
    var passwordProtected: Bool?
    var password: String?
    var contactInfo: String?
    var image: UIImage?
    var identifier: String?
    var host: User
    var moreInfo: String?
    
    var endpoint: String {
        
        return "Events"
    }
    
    var dictionaryCopy: [String:AnyObject] {
        
        guard let description = description,
        passwordProtected = passwordProtected,
        password = password,
        contactInfo = contactInfo,
        image = image,
        identifier = identifier,
        moreInfo = moreInfo else { return ["":""] }
        
        return [titleKey:title, locationKey:location, startTimeKey:startTime, endTimeKey:endTime, descriptionKey:description, passwordProtectedKey:passwordProtected, passwordKey:password, contactInfoKey:contactInfo, imageKey:image]
    }
    
    init(title: String, location: Location, startTime: NSDate, endTime: NSDate, description: String?, passwordProtected: Bool?, password: String?, contactInfo: String?, image: UIImage?, host: User, moreInfo: String) {
        
        self.title = title
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.description = description
        self.passwordProtected = passwordProtected
        self.password = password
        self. contactInfo = contactInfo
        self.image = image
        self.host = host
        self.moreInfo = moreInfo
        self.identifier = nil
    }
    
     required init?(dictionary: [String : AnyObject], identifier: String) {
        
        guard let title = dictionary[titleKey] as? String,
        location = dictionary[locationKey] as? Location,
        startTime = dictionary[startTimeKey] as? NSDate,
        description = dictionary[descriptionKey] as? String,
        passwordProtected = dictionary[passwordProtectedKey] as? Bool,
        password = dictionary[passwordKey] as? String,
        contactInfo = dictionary[contactInfoKey] as? String,
        image = dictionary[imageKey] as? UIImage,
        host = dictionary[hostKey] as? User,
        moreInfo = dictionary[moreInfoKey] as? String else { return nil }
        
        self.title = title
        self.location = location
        self.startTime = startTime
        self.description = description
        self.passwordProtected = passwordProtected
        self.password = password
        self.contactInfo = contactInfo
        self.image = image
        self.host = host
        self.moreInfo = moreInfo
        
      }
}
