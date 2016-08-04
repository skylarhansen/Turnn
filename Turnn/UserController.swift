//
//  UserController.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserController {
    
    static let sharedController = UserController()
    
    private let kUser = "userKey"
    
    var currentUser: User? {
        
        get {
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid,
                userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kUser) as? [String: AnyObject] else { return nil }
            
            return User(dictionary: userDictionary, identifier: uid)
        }
        
        set {
            
            if let newValue = newValue {
                
                NSUserDefaults.standardUserDefaults().setValue(newValue.dictionaryCopy, forKey: kUser)
                print("User Login Values: \(newValue.dictionaryCopy) -- \(kUser)")
                NSUserDefaults.standardUserDefaults().synchronize()
                
            } else {
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    func createUser(email: String, password: String, firstName: String, lastName: String = "") {
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                print(error?.localizedDescription)
                
            } else {
                
                print("User created.")
                
                FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
                    
                    if error != nil {
                        
                        print("Error could not find user with email and password. --> \(error?.localizedDescription)")
                        
                    } else {
                        
                        guard let user = user else { print("Did not get user info back for some reason... "); return }
                        let createdUser = User(firstName: firstName, lastName: lastName, identifier: user.uid)
                        self.currentUser = createdUser
                        
                        print("User logged in. UID = \(self.currentUser?.identifier!)")
                    }
                    
                })
            }
        })
    }
    
    func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        
        FirebaseController.ref.child("Users").child("\(identifier)").observeSingleEventOfType(.Value, withBlock: { (dataSnapshot) in
            if let userDictionary = dataSnapshot.value as? [String : AnyObject] {
                let user = User(dictionary: userDictionary, identifier: identifier)
                completion(user: user)
            } else {
                print("Could not convert FIRDateSnapshot to Dictionary --> \(#function)")
                completion(user: nil)
            }
        })
    }
    
    func authUser(email: String, password: String) {
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("Error could not find user with email and password. --> \(error?.localizedDescription)")
            } else {
                if let user = user {
                    self.userForIdentifier(user.uid, completion: { (user) in
                        if let user = user {
                            self.currentUser = user
                            print("User logged in. UID = \(user.identifier!)")
                        }
                    })
                }
            }
        })
    }
    
    func deleteUser(user: User) {
        
        user.delete()
        if let firebaseUser = FIRAuth.auth()?.currentUser {
            firebaseUser.deleteWithCompletion({ (error) in
                if let error = error {
                    print("Unable to delete user: \(firebaseUser.uid) --> \(error.localizedDescription)")
                }
            })
        }
        currentUser = nil
    }
    
    func updateUser(firstName: String, lastName: String = "") {
        
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let changeRequest = user.profileChangeRequest()
            
            changeRequest.displayName = "\(firstName) \(lastName)"
            changeRequest.commitChangesWithCompletion({ (error) in
                if let error = error {
                    print("Unable to update user: \(user.uid) --> \(error.localizedDescription)")
                } else {
                    print("User info updated. UID = \(user.uid)")
                }
            })
        }
    }
}