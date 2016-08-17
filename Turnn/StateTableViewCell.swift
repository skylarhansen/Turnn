//
//  StateTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/10/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var stateTextField: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCell()
    }
    
    func setupCell() {
        self.stateTextField.delegate = self
        self.backgroundColor = .clearColor()
        self.stateTextField.text = "UT"
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.layer.borderWidth = 0
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
