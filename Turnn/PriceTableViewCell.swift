//
//  PriceTableViewCell.swift
//  Turnn
//
//  Created by Tyler on 8/18/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.hidden = false
        }
    }
    
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            amountLabel.hidden = true
        }
    }
    @IBOutlet weak var amountTextField: AmountTextField! {
        didSet {
            amountTextField.hidden = true
        }
    }
    
    //    weak var freeButton: UIButton! {
    //        layer.cornerRadius = 5
    //        layer.borderWidth = 2
    //        layer.borderColor = UIColor.whiteColor().CGColor
    //
    //        return self.freeButton
    //    }
    //
    //    weak var costButton: UIButton! {
    //        layer.cornerRadius = frame.width / 2
    //        layer.borderWidth = 2
    //        layer.borderColor = UIColor.whiteColor().CGColor
    //
    //        return self.costButton
    //    }
    
    
    @IBAction func freeButtonTapped(sender: AnyObject) {
        (sender as! UIButton).backgroundColor = UIColor.turnnWhite()
        
        
        
    }
    
    @IBAction func costButtonTapped(sender: AnyObject) {
       
        UIView.animateWithDuration(0.3) {
            self.amountLabel.hidden = false
            self.amountTextField.hidden = false
        }
        
        (sender as! UIButton).backgroundColor = UIColor.turnnWhite()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        
    }
    
    func setupCell() {
        self.backgroundColor = .clearColor()
        self.amountTextField.delegate = self
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
            
            UIView.animateWithDuration(0.5) {
                self.backgroundColor = .clearColor()
            }
        }
    }
}

class AmountTextField: UITextField {
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
        //                    addTarget(action: #selector(amountTextField.editingChanged(_:)), forControlEvents: .EditingChanged)
        keyboardType = .NumberPad
        editingChanged(self)
    }
    
    func editingChanged(sender: UITextField) { sender.text = currency }
    
}
