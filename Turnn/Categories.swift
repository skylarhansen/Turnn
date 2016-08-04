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
    
    case Admission
    case BoardGames
    case Basketball
    case Dancing
    case Drinking
    case Food
    case Hackathon
    case Hiking
    case Holiday
    case Movie
    case Music
    case Pin
    case Party
    case Shopping
    case Sports
    case VideoGames
    
    var image: UIImage? {
        switch self {
            
        case .Admission:
            return UIImage(named: "Circle Admission")
        case .BoardGames:
            return UIImage(named: "Circle Games")
        case .Basketball:
            return UIImage(named: "Circle Basketball")
        case .Dancing:
            return UIImage(named: "Circle Dancing")
        case .Drinking:
            return UIImage(named: "Circle Drinking")
        case .Food:
            return UIImage(named: "Circle Food")
        case .Hackathon:
            return UIImage(named: "Circle Hackaton")
        case .Hiking:
            return UIImage(named: "Circle Hiking")
        case .Holiday:
            return UIImage(named: "Circle Holiday")
        case .Movie:
            return UIImage(named: "Circle Video")
        case .Music:
            return UIImage(named: "Circle Music")
        case .Pin:
            return UIImage(named: "Pin")
        case .Party:
            return UIImage(named: "Circle Party")
        case .Shopping:
            return UIImage(named: "Circle Shopping")
        case .Sports:
            return UIImage(named: "Sports")
        case .VideoGames:
            return UIImage(named: "Circle Video Games")
        }
    }
    
    var name: String {
        switch self {
            
        case .Admission:
            return "Admission"
        case .BoardGames:
            return "Board Games"
        case .Basketball:
            return "Basketball"
        case .Dancing:
            return "Dancing"
        case .Drinking:
            return "Drinking"
        case .Food:
            return "Food"
        case .Hackathon:
            return "Hackaton"
        case .Hiking:
            return "Outdoor"
        case .Holiday:
            return "Holiday"
        case .Movie:
            return "Movie"
        case .Music:
            return "Music"
        case .Pin:
            return "Pin"
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
