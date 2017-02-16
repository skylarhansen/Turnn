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
        static let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter
        }()
    }
    var stringValue : String { return text ?? "" }
    var doubleValue : Double { return Double(integerValue) / 100 }
    var integerValue: Int    { return Int(numbersOnly) ?? 0 }
    var currency    : String { return Number.formatter.string(from: NSNumber(value: doubleValue)) ?? "" }
    var numbersOnly : String { return stringValue.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined(separator: "") }
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(CurrencyTextField.editingChanged(_:)), for: .editingChanged)
        keyboardType = .numberPad
        keyboardAppearance = .dark
        editingChanged(self)
    }
    func editingChanged(_ sender: UITextField) { sender.text = currency }
}
