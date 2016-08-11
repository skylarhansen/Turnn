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
    
    case Admission  // 0
    case BoardGames // 1
    case Dancing    // 2
    case Drinking   // 3
    case Food       // 4
    case Hackathon  // 5
    case Hiking     // 6
    case Holiday    // 7
    case Movie      // 8
    case Music      // 9
    case Party      // 10
    case Shopping   // 11
    case Sports     // 12
    case VideoGames // 13
    
    static let count: Int = {
        var max: Int = 0
        while let _ = Categories(rawValue: max) { max += 1 }
        return max
    }()
    
    var grayCircleImage: UIImage? {
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
    
    var selectedCircleImage: UIImage? {
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
    
    var grayImage: UIImage? {
        switch self {
        case .Admission:
            return UIImage(named: "Admission Gray")
        case .BoardGames:
            return UIImage(named: "Board Games Gray")
        case .Dancing:
            return UIImage(named: "Dancing Gray")
        case .Drinking:
            return UIImage(named: "Drinking Gray")
        case .Food:
            return UIImage(named: "Food Gray")
        case .Hackathon:
            return UIImage(named: "Hackathon Gray")
        case .Hiking:
            return UIImage(named: "Hiking Gray")
        case .Holiday:
            return UIImage(named: "Holiday Gray")
        case .Movie:
            return UIImage(named: "Movie Gray")
        case .Music:
            return UIImage(named: "Music Gray")
        case .Party:
            return UIImage(named: "Party Gray")
        case .Shopping:
            return UIImage(named: "Shopping Gray")
        case .Sports:
            return UIImage(named: "Sports Gray")
        case .VideoGames:
            return UIImage(named: "Video Games Gray")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .Admission:
            return UIImage(named: "Admission")
        case .BoardGames:
            return UIImage(named: "Board Games")
        case .Dancing:
            return UIImage(named: "Dancing")
        case .Drinking:
            return UIImage(named: "Drinking")
        case .Food:
            return UIImage(named: "Food")
        case .Hackathon:
            return UIImage(named: "Hackathon")
        case .Hiking:
            return UIImage(named: "Hiking")
        case .Holiday:
            return UIImage(named: "Holiday")
        case .Movie:
            return UIImage(named: "Movie")
        case .Music:
            return UIImage(named: "Music")
        case .Party:
            return UIImage(named: "Party")
        case .Shopping:
            return UIImage(named: "Shopping")
        case .Sports:
            return UIImage(named: "Sports")
        case .VideoGames:
            return UIImage(named: "Video Games")
        }
    }
    // Create Event wont have circle icons grey, then blue when selected
    
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
            return "Outdoors"
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
