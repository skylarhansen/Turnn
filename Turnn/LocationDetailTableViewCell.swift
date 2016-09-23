//
//  LocationDetailTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class LocationDetailTableViewCell: UITableViewCell {

    var event: Event?
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    
    @IBOutlet weak private var addressLabel: TurnnCopyableLabel!
    @IBOutlet weak private var streetNumberLabel: UILabel!
    @IBOutlet weak private var cityStateLabel: UILabel!
    @IBOutlet weak private var zipcodeLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLocationWithEvent(event: Event) {
        addressLabel.text = "\(event.location.address)\n\(event.location.city), \(event.location.state)\n\(event.location.zipCode)"
        //        streetNumberLabel.text = event.location.address
        //        cityStateLabel.text = "\(event.location.city), \(event.location.state)"
        //        zipcodeLabel.text = event.location.zipCode
    }
}
