//
//  TitleTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCell()
    }
    
    func setupCell() {
        self.titleTextField.delegate = self
        self.backgroundColor = .clearColor()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        if textField == titleTextField {
            return newLength <= 33
        }
        return true
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
