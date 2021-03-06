//
//  EndTimeTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/12/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class EndTimeTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak private var endTimeLabel: UILabel!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    var date: NSDate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell() {
        self.endTimeTextField.delegate = self
        self.backgroundColor = .clearColor()
        setupTextfieldInputView()
    }
    
    func setupTextfieldInputView() {
        let datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.datePickerMode = .DateAndTime
        datePicker.backgroundColor = UIColor.turnnGray()
        datePicker.minimumDate = NSDate()
        datePicker.setValue(UIColor.turnnWhite(), forKeyPath: "textColor")
        datePicker.addTarget(self, action: #selector(dateUpdated(_:)), forControlEvents: .ValueChanged)
        self.endTimeTextField.inputView = datePicker
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.layer.borderWidth = 0
        if textField.text == "" {
            date = NSDate()
            textField.text = NSDate().dateLongFormat()
        }
    }
    
    func dateUpdated(datePicker: UIDatePicker) {
        print(datePicker.date)
        self.date = datePicker.date
        self.endTimeTextField.text = datePicker.date.dateLongFormat()
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
