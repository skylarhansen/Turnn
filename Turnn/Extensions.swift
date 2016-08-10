//
//  Extensions.swift
//  Turnn
//
//  Created by Steve Cox on 8/2/16.
//  Copyright © 2016 Team Turnn. All rights reserved.
//

import Foundation
import UIKit

extension NSDate: Comparable {
}

public func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate == rhs.timeIntervalSinceReferenceDate
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

public func + (lhs: NSDate, rhs: NSTimeInterval) -> NSDate {
    return lhs.dateByAddingTimeInterval(rhs)
}

public func - (lhs: NSDate, rhs: NSTimeInterval) -> NSDate {
    return lhs.dateByAddingTimeInterval(-rhs)
}

public func - (lhs: NSDate, rhs: NSDate) -> NSTimeInterval {
    return lhs.timeIntervalSinceDate(rhs)
}

extension UIColor {
    
    class func turnnGray() -> UIColor {
        return UIColor(red: 0.278, green: 0.310, blue: 0.310, alpha: 1.00)
    }
    
    class func turnnBlue() -> UIColor {
        return UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)
    }
    
    class func turnnWhite() -> UIColor {
        return UIColor(red: 0.941, green: 1.000, blue: 1.000, alpha: 1.00)
    }
}

extension UIImage {
    
    func data() -> NSData? {
        let data = UIImageJPEGRepresentation(self, 0.8)
        return data
    }
}

extension UIImageView {
    
    func makeCircular() {
        if self.frame.height == self.frame.width {
            self.layer.cornerRadius = self.frame.height / 2
            self.layer.masksToBounds = true
        } else {
            print("ImageView can not be circular because it is not square")
        }
    }
}

extension UIButton {
    
    func makeCircular() {
        if self.frame.height == self.frame.width {
            self.layer.cornerRadius = self.frame.height / 2
            self.layer.masksToBounds = true
        } else {
            print("Button can not be circular because it is not square")
        }
    }
}

extension Double {
    
    func makeKilometers() -> Double {
        let result = self * 1.60934
        return result
        
    }
}

extension Event {

    func loadCategoriesForEvent() -> [UIImage] {
        var imageArray: [UIImage] = []
        for category in self.categories {
            if let image = Categories(rawValue: category)?.selectedImage {
                imageArray.append(image)
            }
        }
        return imageArray
    }
}

extension String {

    static func autoformatAddressForGPSAquisition(event: Event) -> String {
        return event.location.address + ", " + event.location.city + ", " + event.location.state + ", " + event.location.zipCode
    }
}

extension SequenceType {
    /**
     Returns a tuple with 2 arrays.
     The first array (the slice) contains the elements of self that match the predicate.
     The second array (the remainder) contains the elements of self that do not match the predicate.
     */
    func divide(@noescape predicate: (Self.Generator.Element) -> Bool) -> (slice: [Self.Generator.Element], remainder: [Self.Generator.Element]) {
        var slice:     [Self.Generator.Element] = []
        var remainder: [Self.Generator.Element] = []
        forEach {
            switch predicate($0) {
            case true  : slice.append($0)
            case false : remainder.append($0)
            }
        }
        return (slice, remainder)
    }
}