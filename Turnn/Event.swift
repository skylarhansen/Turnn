//
//  Event.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/1/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import UIKit

class Event {
    
    private let titleKey = "title"
    private let locationKey = "location"
    private let startTimeKey = "startTime"
    private let endTimeKey = "endTime"
    private let descriptionKey = "description"
    private let passwordProtectedKey = "passwordProtected"
    private let passwordKey = "password"
    private let contactInfoKey = "contactInfo"
    private let imageKey = "image"
    
    var title: String = ""
    var location: String = "" // what type should location be?
    var startTime: NSDate
    var endTime: NSDate?
    //    let categories: [Category]
    var description: String?
    var passwordProtected: Bool?
    var password: String?
    var contactInfo: String?
    var image: UIImage?
    var identifier: String?
    //    let host: User      --> what time should host be?
    
    var endpoint: String {
        
        return "events"
    }
    
    var dictionaryCopy: [String:AnyObject] {
        
        
        
        return [titleKey:title, locationKey:location, startTimeKey:startTime, endTimeKey:endTime!, descriptionKey:description!, passwordProtectedKey:passwordProtected!, passwordKey:password!, contactInfoKey:contactInfo!, imageKey:image!]
    
}


 