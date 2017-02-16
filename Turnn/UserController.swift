//
//  UserController.swift
//  MyPets
//
//  Created by Nathan on 6/8/16.
//  Copyright © 2016 Falcone Development. All rights reserved.
//

import Foundation
import Firebase
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class UserController {
    
    static let currentUserKey = "currentUser"
    static let currentUserIdKey = "currentUserIdentifier"
    
    static let shared = UserController()
    
    var currentUser: User? = UserController.loadFromDefaults()
    
    var currentUserId: String {
        guard let currentUser = currentUser, let currentUserId = currentUser.identifier else {
            print("current user is nil")
            return "nada"
        }
        return currentUserId
    }
    
    static func createUser(_ firstName: String, lastName: String, paid: Bool, email: String, password: String, completion: @escaping (_ user: User?, _ error: NSError?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("There was error while creating user: \(error.localizedDescription)")
                completion(nil, error as NSError?)
            } else if let firebaseUser = user {
                var user = User(firstName: firstName, lastName: lastName, paid: paid, identifier: firebaseUser.uid)
                user.save()
                UserController.shared.currentUser = user
                UserController.saveUserInDefaults(user)
                completion(user, error as NSError?)
            } else {
                completion(nil, error as NSError?)
            }
        })
    }
    
    static func updateEventIDsForCurrentUser(_ eventID: String?, completion: (_ success: Bool) -> Void) {
        if let eventID = eventID {
            if UserController.shared.currentUser?.eventIds?.count > 0 {
                UserController.shared.currentUser?.eventIds?.append(eventID)
                //UserController.shared.currentUser?.save()
                FirebaseController.ref.child("Users").child(UserController.shared.currentUserId).child("events").child(eventID).setValue(true)
                completion(true)
            } else {
                UserController.shared.currentUser?.eventIds = [eventID]
                //UserController.shared.currentUser?.save()
                FirebaseController.ref.child("Users").child(UserController.shared.currentUserId).child("events").child(eventID).setValue(true)
                completion(true)
            }
        } else {
            print("Could not update User: EventID was nil")
            completion(false)
        }
    }
    
    static func authUser(_ email: String, password: String, completion: @escaping (_ user: User?, _ error: NSError?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firebaseUser, error) in
            if let error = error {
                print("Wasn't able log user in: \(error.localizedDescription)")
                completion(nil, error as NSError?)
            } else if let firebaseUser = firebaseUser {
                UserController.fetchUserForIdentifier(firebaseUser.uid, completion: { (user) in
                    guard let user = user else {
                        completion(nil, error as NSError?)
                        return
                    }
                    UserController.shared.currentUser = user
                    UserController.saveUserInDefaults(user)
                    completion(user, error as NSError?)
                })
            } else {
                completion(nil, error as NSError?)
            }
        })
    }
    
    static func restoreUserIdToDevice(){
    let firuserid = FIRAuth.auth()?.currentUser?.uid
        if firuserid != nil {
        UserController.fetchUserForIdentifier(firuserid!) { (user) in
            guard let user = user else {return}
            UserController.shared.currentUser = user
            UserController.saveUserInDefaults(user)
        }
        }
    }
    
    static func logOutUser(){
        try! FIRAuth.auth()!.signOut()
        clearLocallySavedUserOnLogout()
        UserController.shared.currentUser = nil
    }
    
    static func fetchUserForIdentifier(_ identifier: String, completion: @escaping (_ user: User?) -> Void) {
        FirebaseController.ref.child("Users").child(identifier).observeSingleEvent(of: .value, with: { data in
            guard let dataDict = data.value as? [String: AnyObject],
                let user = User(dictionary: dataDict, identifier: identifier) else {
                    completion(nil)
                    return
            }
            completion(user)
        })
    }
    
    static func isLoggedInServerTest(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        if let currentUser = FIRAuth.auth()?.currentUser {
            currentUser.getTokenForcingRefresh(true) { (idToken, error) in
                if let error = error {
                    completion(false, error as NSError?)
                    print(error.localizedDescription)
                } else {
                    UserController.shared.currentUser = loadFromDefaults()
                    completion(true, nil)
                }
            }
        } else {
            completion(false, nil)
        }
    }
    
    static func clearLocallySavedUserOnLogout(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserController.currentUserKey)
        defaults.removeObject(forKey: currentUserIdKey)
        defaults.synchronize()
    }
    
    static func saveUserInDefaults(_ user: User) {
        UserDefaults.standard.set(user.dictionaryCopy, forKey: UserController.currentUserKey)
        UserDefaults.standard.set(user.identifier!, forKey: currentUserIdKey)
    }
    
    static func loadFromDefaults() -> User? {
        let defaults = UserDefaults.standard
        guard let userId = defaults.object(forKey: currentUserIdKey) as? String else {
            return nil
        }
        
        fetchUserForIdentifier(userId) { (user) in
            UserController.shared.currentUser = user
        }
        return nil
    }
}
