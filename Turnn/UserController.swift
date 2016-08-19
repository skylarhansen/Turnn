//
//  UserController.swift
//  MyPets
//
//  Created by Nathan on 6/8/16.
//  Copyright © 2016 Falcone Development. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    static let currentUserKey = "currentUser"
    static let currentUserIdKey = "currentUserIdentifier"
    
//    var currentUserId = "currentUser" // TODO: replace with actual current user id
    
    static let shared = UserController()
    
    // TODO: Uncomment when we have a user object
    var currentUser: User? = UserController.loadFromDefaults()
    
    var currentUserId: String {
        guard let currentUser = currentUser, currentUserId = currentUser.identifier else {
            fatalError("Could not retrieve current user id")
        }
        return currentUserId
    }
    
    static func createUser(firstName: String, lastName: String, paid: Bool, email: String, password: String, completion: (user: User?, error: NSError?) -> Void) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let error = error {
                print("There was error while creating user: \(error.localizedDescription)")
                completion(user: nil, error: error)
            } else if let firebaseUser = user {
                var user = User(firstName: firstName, lastName: lastName, paid: paid, identifier: firebaseUser.uid)
                user.save()
                UserController.shared.currentUser = user
                UserController.saveUserInDefaults(user)
                completion(user: user, error: error)
            } else {
                completion(user: nil, error: error)
            }
        })
    }
    
    static func updateEventIDsForCurrentUser(eventID: String?, completion: (success: Bool) -> Void) {
        if let eventID = eventID {
            if UserController.shared.currentUser?.eventIds?.count > 0 {
                UserController.shared.currentUser?.eventIds?.append(eventID)
                UserController.shared.currentUser?.save()
                completion(success: true)
            } else {
                UserController.shared.currentUser?.eventIds = [eventID]
                UserController.shared.currentUser?.save()
                completion(success: true)
            }
        } else {
            print("Could not update User: EventID was nil")
            completion(success: false)
        }
    }
    
    static func authUser(email: String, password: String, completion: (user: User?, error: NSError?) -> Void) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (firebaseUser, error) in
            if let error = error {
                print("Wasn't able log user in: \(error.localizedDescription)")
                completion(user: nil, error: error)
            } else if let firebaseUser = firebaseUser {
                UserController.fetchUserForIdentifier(firebaseUser.uid, completion: { (user) in
                    guard let user = user else {
                        completion(user: nil, error: error)
                        return
                    }
                    UserController.shared.currentUser = user
                    UserController.saveUserInDefaults(user)
                    completion(user: user, error: error)
                })
            } else {
                completion(user: nil, error: error)
            }
        })
    }
    
    static func logOutUser(){
        try! FIRAuth.auth()!.signOut()
        clearLocallySavedUserOnLogout()
        UserController.shared.currentUser = nil
    }
    
    static func fetchUserForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        FirebaseController.ref.child("Users").child(identifier).observeSingleEventOfType(.Value, withBlock: { data in
            guard let dataDict = data.value as? [String: AnyObject],
                user = User(dictionary: dataDict, identifier: identifier) else {
                    completion(user: nil)
                    return
            }
            completion(user: user)
        })
    }
    
    static func isLoggedInServerTest(completion: (success: Bool, error: NSError?) -> Void) {
        if let currentUser = FIRAuth.auth()?.currentUser {
            currentUser.getTokenForcingRefresh(true) { (idToken, error) in
                if let error = error {
                    completion(success: false, error: error)
                    print(error.localizedDescription)
                } else {
                    UserController.shared.currentUser = loadFromDefaults()
                    completion(success: true, error: nil)
                }
            }
        } else {
            completion(success: false, error: nil)
        }
    }
    
    static func clearLocallySavedUserOnLogout(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(UserController.currentUserKey)
        defaults.removeObjectForKey(currentUserIdKey)
        defaults.synchronize()
    }
    
    static func saveUserInDefaults(user: User) {
        NSUserDefaults.standardUserDefaults().setObject(user.dictionaryCopy, forKey: UserController.currentUserKey)
        NSUserDefaults.standardUserDefaults().setObject(user.identifier!, forKey: currentUserIdKey)
    }
    
    static func loadFromDefaults() -> User? {
        let defaults = NSUserDefaults.standardUserDefaults()
        guard let userId = defaults.objectForKey(currentUserIdKey) as? String else {
            return nil
        }
        
        fetchUserForIdentifier(userId) { (user) in
            UserController.shared.currentUser = user
        }
        return nil
    }
}