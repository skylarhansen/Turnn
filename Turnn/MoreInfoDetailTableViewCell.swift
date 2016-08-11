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
//        moreInfoLabel.layer.borderColor = UIColor.turnnBlue().CGColor
//        moreInfoLabel.layer.borderWidth = 1
//        moreInfoLabel.layer.cornerRadius = 3
//        moreInfoLabel.layer.masksToBounds = true
    }

    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoTextView: UITextView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateMoreInfoWithEvent(event: Event) {
        moreInfoTextView.text = event.moreInfo
    }

}
