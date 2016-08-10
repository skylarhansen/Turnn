//
//  DateFormatter.swift
//  Turnn
//
//  Created by Tyler on 8/10/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import Foundation

extension NSDate {
    func dateFormat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(self)
    }
}