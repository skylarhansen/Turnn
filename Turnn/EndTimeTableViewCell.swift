//
//  EndTimeTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/12/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class EndTimeTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak fileprivate var endTimeLabel: UILabel!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    var date: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell() {
        self.endTimeTextField.delegate = self
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
        self.endTimeTextField.inputView = datePicker
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
        self.date = datePicker.date
        self.endTimeTextField.text = datePicker.date.dateLongFormat()
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
