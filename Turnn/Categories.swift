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
    case Alcohol
    case BoardGames
    case Dancing
    case Food
    case Hackathon
    case Holiday
    case Movie
    case Music
    case Outdoor
    case Pin
    case Party
    case Shopping
    case Sports
    case VideoGames
    
    var image: UIImage? {
        switch self {
            
        case .Admission:
            return UIImage(named: "Admission")
        case .Alcohol:
            return UIImage(named: "Alcohol")
        case .BoardGames:
            return UIImage(named: "Board Games")
        case .Dancing:
            return UIImage(named: "Dancing")
        case .Food:
            return UIImage(named: "Food")
        case .Hackathon:
            return UIImage(named: "Hackaton")
        case .Holiday:
            return UIImage(named: "Holiday")
        case .Movie:
            return UIImage(named: "Movie")
        case .Music:
            return UIImage(named: "Music")
        case .Outdoor:
            return UIImage(named: "Outdoor")
        case .Pin:
            return UIImage(named: "Pin")
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
    
    var name: String {
        switch self {
            
        case .Admission:
            return "Admission"
        case .Alcohol:
            return "Alcohol"
        case .BoardGames:
            return "BoardGames"
        case .Dancing:
            return "Dancing"
        case .Food:
            return "Food"
        case .Hackaton:
            return "Hackaton"
        case .Holiday:
            return "Holiday"
        case .Movie:
            return "Movie"
        case .Music:
            return "Music"
        case .Outdoor:
            return "Outdoor"
        case .Pin:
            return "Pin"
        case .Party:
            return "Party"
        case .Shopping:
            return "Shopping"
        case .Sports:
            return "Sports"
        case .VideoGames:
            return "VideoGames"
        }
    }
}
