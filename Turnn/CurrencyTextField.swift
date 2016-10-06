//
//  CurrencyTextField.swift
//  Turnn
//
//  Created by Tyler on 8/19/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {
    
    struct Number {
        static let formatter: NSNumberFormatter = {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            return formatter
        }()
    }
    var stringValue : String { return text ?? "" }
    var doubleValue : Double { return Double(integerValue) / 100 }
    var integerValue: Int    { return Int(numbersOnly) ?? 0 }
    var currency    : String { return Number.formatter.stringFromNumber(doubleValue) ?? "" }
    var numbersOnly : String { return stringValue.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789").invertedSet).joinWithSeparator("") }
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(CurrencyTextField.editingChanged(_:)), forControlEvents: .EditingChanged)
        keyboardType = .NumberPad
        keyboardAppearance = .Dark
        editingChanged(self)
    }
    func editingChanged(sender: UITextField) { sender.text = currency }
}
