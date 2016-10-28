//
//  DescriptionDetailTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class DescriptionDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak var detailedDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateDescriptionWithEvent(event: Event) {
        detailedDescriptionLabel.text = event.eventDescription
    }

}
