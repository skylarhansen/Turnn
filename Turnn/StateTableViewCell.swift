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
        self.backgroundColor = .clear
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        if textField == stateTextField {
            return newLength <= 15
        }
        return true
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
