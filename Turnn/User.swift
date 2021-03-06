//
//  User.swift
//
//
//  Created by Skylar Hansen on 8/1/16.
//
//

import Foundation

class User: FirebaseType {
    
    private let firstNameKey = "firstName"
    private let lastNameKey = "lastName"
    private let identifierKey = "id"
    private let paidKey = "paid"
    private let eventsKey = "events"
    
    var firstName: String
    var lastName: String?
    var events: [Event]?
    var eventIds: [String]?
    //    var eventCount: Int {}
    var paid: Bool
    var identifier: String?
    
    var endpoint: String {
        return "Users"
    }
    
    var dictionaryCopy: [String:AnyObject] {
        
        var dictionary: [String: AnyObject] = [firstNameKey: firstName, paidKey: paid]
        
        if let lastName = lastName {
            dictionary.updateValue(lastName, forKey: lastNameKey)
        }
        
        if let events = eventIds {
            dictionary.updateValue(events, forKey: eventsKey)
        }
        return dictionary
    }
    
    init(firstName: String, lastName: String?, events: [Event] = [], paid: Bool = false, identifier: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.events = events
        self.paid = paid
        self.eventIds = events.flatMap { $0.identifier }
        self.identifier = identifier
    }
    
    required init?(dictionary: [String:AnyObject], identifier: String) {
        
        guard let firstName = dictionary[firstNameKey] as? String,
            lastName = dictionary[lastNameKey] as? String,
            paid = dictionary[paidKey] as? Bool else { return nil }
        
        if let eventIds = dictionary[eventsKey] as? [String] {
            self.eventIds = eventIds
            print(eventIds)
        }

        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.paid = paid
    }
}