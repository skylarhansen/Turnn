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
    
    case admission  // 0
    case boardGames // 1
    case dancing    // 2
    case drinking   // 3
    case food       // 4
    case hackathon  // 5
    case hiking     // 6
    case holiday    // 7
    case movie      // 8
    case music      // 9
    case party      // 10
    case shopping   // 11
    case sports     // 12
    case videoGames // 13
    
    static let count: Int = {
        var max: Int = 0
        while let _ = Categories(rawValue: max) { max += 1 }
        return max
    }()
    
    var grayCircleImage: UIImage? {
        switch self {
            
        case .admission:
            return UIImage(named: "Circle Admission Gray")
        case .boardGames:
            return UIImage(named: "Circle Board Games Gray")
        case .dancing:
            return UIImage(named: "Circle Dancing Gray")
        case .drinking:
            return UIImage(named: "Circle Drinking Gray")
        case .food:
            return UIImage(named: "Circle Food Gray")
        case .hackathon:
            return UIImage(named: "Circle Hackathon Gray")
        case .hiking:
            return UIImage(named: "Circle Hiking Gray")
        case .holiday:
            return UIImage(named: "Circle Holiday Gray")
        case .movie:
            return UIImage(named: "Circle Movie Gray")
        case .music:
            return UIImage(named: "Circle Music Gray")
        case .party:
            return UIImage(named: "Circle Party Gray")
        case .shopping:
            return UIImage(named: "Circle Shopping Gray")
        case .sports:
            return UIImage(named: "Circle Sports Gray")
        case .videoGames:
            return UIImage(named: "Circle Video Games Gray")
        }
    }
    
    var selectedCircleImage: UIImage? {
        switch self {
        case .admission:
            return UIImage(named: "Circle Admission")
        case .boardGames:
            return UIImage(named: "Circle Board Games")
        case .dancing:
            return UIImage(named: "Circle Dancing")
        case .drinking:
            return UIImage(named: "Circle Drinking")
        case .food:
            return UIImage(named: "Circle Food")
        case .hackathon:
            return UIImage(named: "Circle Hackathon")
        case .hiking:
            return UIImage(named: "Circle Hiking")
        case .holiday:
            return UIImage(named: "Circle Holiday")
        case .movie:
            return UIImage(named: "Circle Movie")
        case .music:
            return UIImage(named: "Circle Music")
        case .party:
            return UIImage(named: "Circle Party")
        case .shopping:
            return UIImage(named: "Circle Shopping")
        case .sports:
            return UIImage(named: "Circle Sports")
        case .videoGames:
            return UIImage(named: "Circle Video Games")
        }
    }
    
    var grayImage: UIImage? {
        switch self {
        case .admission:
            return UIImage(named: "Admission Gray")
        case .boardGames:
            return UIImage(named: "Board Games Gray")
        case .dancing:
            return UIImage(named: "Dancing Gray")
        case .drinking:
            return UIImage(named: "Drinking Gray")
        case .food:
            return UIImage(named: "Food Gray")
        case .hackathon:
            return UIImage(named: "Hackathon Gray")
        case .hiking:
            return UIImage(named: "Hiking Gray")
        case .holiday:
            return UIImage(named: "Holiday Gray")
        case .movie:
            return UIImage(named: "Movie Gray")
        case .music:
            return UIImage(named: "Music Gray")
        case .party:
            return UIImage(named: "Party Gray")
        case .shopping:
            return UIImage(named: "Shopping Gray")
        case .sports:
            return UIImage(named: "Sports Gray")
        case .videoGames:
            return UIImage(named: "Video Games Gray")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .admission:
            return UIImage(named: "Admission")
        case .boardGames:
            return UIImage(named: "Board Games")
        case .dancing:
            return UIImage(named: "Dancing")
        case .drinking:
            return UIImage(named: "Drinking")
        case .food:
            return UIImage(named: "Food")
        case .hackathon:
            return UIImage(named: "Hackathon")
        case .hiking:
            return UIImage(named: "Hiking")
        case .holiday:
            return UIImage(named: "Holiday")
        case .movie:
            return UIImage(named: "Movie")
        case .music:
            return UIImage(named: "Music")
        case .party:
            return UIImage(named: "Party")
        case .shopping:
            return UIImage(named: "Shopping")
        case .sports:
            return UIImage(named: "Sports")
        case .videoGames:
            return UIImage(named: "Video Games")
        }
    }
    // Create Event wont have circle icons grey, then blue when selected
    
    var name: String? {
        switch self {
            
        case .admission:
            return "Admission"
        case .boardGames:
            return "Board Games"
        case .dancing:
            return "Dancing"
        case .drinking:
            return "Drinking"
        case .food:
            return "Food"
        case .hackathon:
            return "Hackathon"
        case .hiking:
            return "Outdoors"
        case .holiday:
            return "Holiday"
        case .movie:
            return "Movie"
        case .music:
            return "Music"
        case .party:
            return "Party"
        case .shopping:
            return "Shopping"
        case .sports:
            return "Sports"
        case .videoGames:
            return "Video Games"
        }
    }
}
