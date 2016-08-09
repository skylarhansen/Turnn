//
//  TimeTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
    weak var delegate: timeTextFieldDelegate?
    
    func setupCell() {
        self.backgroundColor = .clearColor()
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

protocol timeTextFieldDelegate: class {
    
}
