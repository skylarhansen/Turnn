//
//  Categories.swift
//  Turnn
//
//  Created by Tyler on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation
import UIKit

enum Categories: Int {
    
<<<<<<< HEAD
    case Admission
    case BoardGames
    case Dancing
    case Drinking
    case Food
    case Hackathon
    case Hiking
    case Holiday
    case Movie
    case Music
    case Party
    case Shopping
    case Sports
    case VideoGames
=======
    case Admission  // 0
    case BoardGames // 1
    case Basketball // 2
    case Dancing    // 3
    case Drinking   // 4
    case Food       // 5
    case Hackathon  // 6
    case Hiking     // 7
    case Holiday    // 8
    case Movie      // 9
    case Music      // 10
    case Pin        // 11
    case Party      // 12
    case Shopping   // 13
    case Sports     // 14
    case VideoGames // 15
>>>>>>> feature/making_event_creation_possible
    
    static let count: Int = {
        var max: Int = 0
        while let _ = Categories(rawValue: max) { max += 1 }
        return max
    }()
    
    var image: UIImage? {
        switch self {
            
        case .Admission:
            return UIImage(named: "Circle Admission Gray")
        case .BoardGames:
            return UIImage(named: "Circle Board Games Gray")
        case .Dancing:
            return UIImage(named: "Circle Dancing Gray")
        case .Drinking:
            return UIImage(named: "Circle Drinking Gray")
        case .Food:
            return UIImage(named: "Circle Food Gray")
        case .Hackathon:
            return UIImage(named: "Circle Hackathon Gray")
        case .Hiking:
            return UIImage(named: "Circle Hiking Gray")
        case .Holiday:
            return UIImage(named: "Circle Holiday Gray")
        case .Movie:
            return UIImage(named: "Circle Movie Gray")
        case .Music:
            return UIImage(named: "Circle Music Gray")
        case .Party:
            return UIImage(named: "Circle Party Gray")
        case .Shopping:
            return UIImage(named: "Circle Shopping Gray")
        case .Sports:
            return UIImage(named: "Circle Sports Gray")
        case .VideoGames:
            return UIImage(named: "Circle Video Games Gray")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .Admission:
            return UIImage(named: "Circle Admission")
        case .BoardGames:
            return UIImage(named: "Circle Board Games")
        case .Dancing:
            return UIImage(named: "Circle Dancing")
        case .Drinking:
            return UIImage(named: "Circle Drinking")
        case .Food:
            return UIImage(named: "Circle Food")
        case .Hackathon:
            return UIImage(named: "Circle Hackathon")
        case .Hiking:
            return UIImage(named: "Circle Hiking")
        case .Holiday:
            return UIImage(named: "Circle Holiday")
        case .Movie:
            return UIImage(named: "Circle Movie")
        case .Music:
            return UIImage(named: "Circle Music")
        case .Party:
            return UIImage(named: "Circle Party")
        case .Shopping:
            return UIImage(named: "Circle Shopping")
        case .Sports:
            return UIImage(named: "Circle Sports")
        case .VideoGames:
            return UIImage(named: "Circle Video Games")
        }
    }
    
    var name: String? {
        switch self {
            
        case .Admission:
            return "Admission"
        case .BoardGames:
            return "Board Games"
        case .Dancing:
            return "Dancing"
        case .Drinking:
            return "Drinking"
        case .Food:
            return "Food"
        case .Hackathon:
            return "Hackathon"
        case .Hiking:
            return "Outdoor"
        case .Holiday:
            return "Holiday"
        case .Movie:
            return "Movie"
        case .Music:
            return "Music"
        case .Party:
            return "Party"
        case .Shopping:
            return "Shopping"
        case .Sports:
            return "Sports"
        case .VideoGames:
            return "Video Games"
        }
    }
}
