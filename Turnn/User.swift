//
//  User.swift
//
//
//  Created by Skylar Hansen on 8/1/16.
//
//

import Foundation

class User: FirebaseType {
    
    private let hostNameKey = "hostName"
    private let paidKey = "paid"
    private let eventsKey = "events"
    
    var hostName: String
    var events: [Event]?
    //    var eventCount: Int {}
    var paid: Bool
    //    let latitude: Double {}
    //    let longitude: Double {}
    var identifier: String?
    
    var endpoint: String {
        
        return "Users"
    }
    
    var dictionaryCopy: [String:AnyObject] {
        
        guard let events = events else { return self.dictionaryCopy }
        let eventIds = events.flatMap { $0.identifier }
        var dictionary: [String: AnyObject] = [eventsKey: eventIds.map { [$0: true] }]
        
        if let identifier = identifier {
            dictionary.updateValue(eventIds, forKey: eventsKey)
            dictionary.updateValue(identifier, forKey: identifier)
        }
        return dictionary
    }
    
    init(firstName: String, lastName: String = "", identifier: String, events: [Event] = [], paid: Bool = false) {
        
        self.hostName = firstName + " " + lastName
        self.paid = paid
        self.identifier = identifier
        self.events = events
    }
    
    required init?(dictionary: [String:AnyObject], identifier: String) {
        
        guard let hostName = dictionary[hostNameKey] as? String,
            paid = dictionary[paidKey] as? Bool else { return nil }
        
        self.hostName = hostName
        self.paid = paid
    }
}