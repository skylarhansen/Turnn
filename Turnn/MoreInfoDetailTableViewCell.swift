//
//  MoreInfoDetailTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class MoreInfoDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak private var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateMoreInfoWithEvent(event: Event) {
        moreInfoDetailLabel.text = event.moreInfo
    }

}


