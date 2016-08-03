//
//  MoreInfoDetailTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class MoreInfoDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var moreInfoLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateMoreInfoWithEvent(event: Event) {
        moreInfoLabel.text = event.moreInfo
    }

}
