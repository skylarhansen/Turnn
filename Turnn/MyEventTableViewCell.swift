//
//  MyEventTableViewCell.swift
//  Turnn
//
//  Created by Justin Smith on 8/18/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class MyEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var eventTitleLabel: UILabel!
    @IBOutlet weak private var eventDateTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell() {
        self.backgroundColor = .clearColor()
    }
    
    func updateWithEvent(event: Event) {
        eventTitleLabel.text = "• \(event.title)"
        eventDateTitleLabel.text =  "  \(event.startTime.dateLongFormat())"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            
            UIView.animateWithDuration(0.4) {
                self.backgroundColor = .clearColor()
            }
        }
    }
}
