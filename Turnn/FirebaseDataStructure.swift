//
//  FirebaseDataStructure.swift
//  Turnn
//
//  Created by Steve Cox on 8/4/16.
//  Copyright © 2016 Team Turnn. All rights reserved.
//

/*  FIREBASE DATA STRUCTURE REFERENCE
 
 events
     - identifier
         - title: titleString
         - location:
             - lat: Double
             - long: Double
             - address: String
             - city: String
             - state: String
             - zip: String
         - startTime: Double
         - endTime: Double
         - categories
             - identifier: true
             - identifier: true
         - description: String
         - passwordPro: Bool
         - password: String
         - contactInfo: String
 
 user
     - identifier
     (email and password managed by Firebase directly)
         - username: String
         - hostname: String
         - paid: Bool
         - events
             - identifier: true
             - identifier: true
 */
