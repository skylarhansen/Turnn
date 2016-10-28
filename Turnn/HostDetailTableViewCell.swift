//
//  HostDetailTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class HostDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBOutlet weak private var hostLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateHostWithEvent(event: Event) {
        hostNameLabel.text = "\(event.host.firstName)  \((event.host.lastName ?? ""))"
    }
}
