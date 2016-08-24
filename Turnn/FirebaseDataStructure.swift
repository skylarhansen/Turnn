//
//  FirebaseDataStructure.swift
//  Turnn
//
//  Created by Steve Cox on 8/4/16.
//  Copyright © 2016 Team Turnn. All rights reserved.
//

/*  FIREBASE DATA STRUCTURE REFERENCE
 
 (all identifiers are Strings generated by Firebase.
  in some cases we'll need to retrieve formerly created
  identifers [like when we append an event identifer to a
  user's record, etc.])
 
 Events:
     - (identifier) String:
         - title: String
         - location:
             - lat: Double
             - long: Double
             - address: String
             - city: String
             - state: String
             - zip: String
             - latitude: Double
             - longitude: Double
         - startTime: Double
         - endTime: Double
         - categories:
             - 0: true
             - 1: true
             - 2 (and so on): true
         - description: String
         - passwordPro: Bool
         - password: String
         - price: Double
         - contactInfo: String
         - host: (identifier) String
         - LocationID: (identifier) String
 
 Users:
     - (identifier) String: (horked from UID in Firebase User console)
         - username: String
         - hostname: String
         - paid: Bool
         - events:
             - (identifier) String: true
             - (identifier) String: true
 
 Locations
     - (identifier):
         - g:  (geohash--String)       [generated by GeoFire]
         - l:                          [generated by GeoFire]
             - 0:  (latitude--Double)  [generated by GeoFire]
             - 1:  (longitude--Double) [generated by GeoFire]
         - EventID: (identifier) String
 
 */
/*
 backup of Firebase Database rules
 as they currently stand at Thu 11 Aug 8pm
 
 {
 "rules": {
 "Events": {
 ".read" : "auth != null",
 ".write" : "auth != null"
 },
 "Users": {
 ".read" : "auth != null",
 ".write" : "auth != null"
 },
 "Locations": {
 ".read": "auth != null",
 ".write": "auth != null",
 ".indexOn": "g",
 "geofire": {
 },
 }
 }
 }
*/