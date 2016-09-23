//
//  TimeTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    var date: NSDate?
      override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
      
    func setupCell() {
        self.timeTextField.delegate = self
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
        self.timeTextField.inputView = datePicker
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
    func dateUpdated(datePicker: UIDatePicker) {
        print(datePicker.date)
        self.date = datePicker.date
        self.timeTextField.text = datePicker.date.dateLongFormat()
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
