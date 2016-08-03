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
        
        return "User"
    }
    
    var dictionaryCopy: [String:AnyObject] {
        
        var dictionary: [String: AnyObject] = [eventsKey: events]
        
        if let events = events, identifier = identifier {
            dictionary.updateValue(events, forKey: eventsKey)
            dictionary.updateValue(identifier, forKey: identifier)
        }
        return dictionary
    }
    
    init(hostName: String, events: [Event] = [], paid: Bool = false) {
        
        self.hostName = hostName
        self.paid = paid
        self.identifier = nil
        self.events = events
    }
    
    required init?(dictionary: [String:AnyObject], identifier: String) {
        
        guard let hostName = dictionary[hostNameKey] as? String,
            paid = dictionary[paidKey] as? Bool else { return nil }
        
        self.hostName = hostName
        self.paid = paid
    }
}