//
//  TimeTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak fileprivate var timeLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    var date: Date?
      override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
      
    func setupCell() {
        self.timeTextField.delegate = self
        self.backgroundColor = .clear
        setupTextfieldInputView()
    }
    
    func setupTextfieldInputView() {
        let datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = UIColor.turnnGray()
        datePicker.minimumDate = Date()
        datePicker.setValue(UIColor.turnnWhite(), forKeyPath: "textColor")
        datePicker.addTarget(self, action: #selector(dateUpdated(_:)), for: .valueChanged)
        self.timeTextField.inputView = datePicker
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        if textField.text == "" {
            date = Date()
            textField.text = Date().dateLongFormat()
        }
    }
    
    func dateUpdated(_ datePicker: UIDatePicker) {
        print(datePicker.date)
        date = datePicker.date
        timeTextField.text = datePicker.date.dateLongFormat()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.backgroundColor = .clear
            }) 
        }
    }
}
