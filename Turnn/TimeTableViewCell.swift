//
//  TimeTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    let timeFormatter = NSDateFormatter()

    @IBAction func timePickerChanged(sender: AnyObject) {
        setDateAndTime()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
    func setDateAndTime() {
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeTextField.text = timeFormatter.stringFromDate(timePicker.date)
    }
    
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
