//
//  DescriptionDetailTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class DescriptionDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailedDescriptionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        descriptionTextView.contentInset = UIEdgeInsetsMake(-7.0, 0.0, 0.0, 0.0)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDescriptionWithEvent(event: Event) {
        detailedDescriptionLabel.text = event.eventDescription
    }

}
