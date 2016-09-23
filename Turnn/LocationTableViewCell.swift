//
//  LocationTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak private var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCell()
    }
    
    func setupCell() {
        self.backgroundColor = .clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected == true {
            self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
            
            UIView.animateWithDuration(0.5) {
                self.backgroundColor = .clearColor()
            }
        }
    }
}
