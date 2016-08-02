//
//  EventFinderTableViewCell.swift
//  Turnn
//
//  Created by Tyler on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class EventFinderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var icon1ImageView: UIImageView!
    @IBOutlet weak var icon2ImageView: UIImageView!
    @IBOutlet weak var icon3ImageView: UIImageView!
    @IBOutlet weak var icon4ImageView: UIImageView!
    @IBOutlet weak var icon5ImageView: UIImageView!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
