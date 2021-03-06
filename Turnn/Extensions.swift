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

extension NSDate {
    
    func dateFormat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(self)
    }
    
    func dateLongFormat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        
        return dateFormatter.stringFromDate(self)
    }
    
    func dateOnly() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        return dateFormatter.stringFromDate(self)
    }
    
    static func dateFromString(string: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.dateFromString(string) {
            return date
        } else {
            return nil
        }
    }
}

extension UIColor {
    
    class func turnnGray() -> UIColor {
        return UIColor(red: 0.184, green: 0.184, blue: 0.184, alpha: 1.00)
    }
    
    class func turnnBlue() -> UIColor {
        return UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)
    }
    
    class func turnnWhite() -> UIColor {
        return UIColor(red: 0.941, green: 1.000, blue: 1.000, alpha: 1.00)
    }
    
    class func error() -> UIColor {
        return UIColor(red: 1.000, green: 0.227, blue: 0.318, alpha: 1.00)
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
    
    func makeMeters() -> Double {
        let result = self * 1609.344
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
    
    static func autoformatAddressForGPSAquisitionWith(event: Event) -> String {
        return event.location.address + ", " + event.location.city + ", " + event.location.state + ", " + event.location.zipCode
    }
    
    static func autoformatAddressForGPSAquistionWith(address: String, city: String, state: String, zipCode: String) -> String {
        return address + ", " + city + ", " + state + ", " + zipCode
    }
    
    static func printEvents(currentEvents: [Event], oldEvents: [Event], futureEvents: [Event]) {
        print("\n|------------------------| \n" + "|    RETRIEVED EVENTS    |")
        print("|                         -----------------------------------------------------------")
        print("|\tCurrent Events: \n|\t\t \(currentEvents)" + "\n|")
        print("|\tOld Events: \n|\t\t \(oldEvents)" + "\n|")
        print("|\tFuture Events: \n|\t\t \(futureEvents)" + "\n|")
        print("--------------------------------------------------------------------------------------\n")
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