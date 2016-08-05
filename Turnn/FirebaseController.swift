//
//  FirebaseController.swift
//  
//
//  Created by Skylar Hansen on 8/1/16.
//
//

import Foundation
import Firebase

class FirebaseController {
    static let ref = FIRDatabase.database().reference()
}

protocol FirebaseType {
    var endpoint: String {get}
    var identifier: String? {get set}
    var dictionaryCopy: [String: AnyObject] {get}
    
    init?(dictionary: [String: AnyObject], identifier: String)
    
    mutating func save()
    func delete()
}

extension FirebaseType {
    
    mutating func save() {
        var newEndpoint = FirebaseController.ref.child(endpoint)
        if let identifier = identifier {
            newEndpoint = newEndpoint.child(identifier)
        } else {
            newEndpoint = newEndpoint.childByAutoId()
            self.identifier = newEndpoint.key
        }
        newEndpoint.setValue(dictionaryCopy)
        //newEndpoint.updateChildValues(dictionaryCopy)
    }
    
    func delete() {
        guard let identifier = identifier else {
            return
        }
        FirebaseController.ref.child(endpoint).child(identifier).removeValue()
    }
}