//
//  Extensions.swift
//  Turnn
//
//  Created by Steve Cox on 8/2/16.
//  Copyright © 2016 Team Turnn. All rights reserved.
//

import Foundation

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