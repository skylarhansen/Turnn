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

    
    @IBOutlet weak fileprivate var addressLabel: TurnnCopyableLabel!
    @IBOutlet weak fileprivate var streetNumberLabel: UILabel!
    @IBOutlet weak fileprivate var cityStateLabel: UILabel!
    @IBOutlet weak fileprivate var zipcodeLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLocationWithEvent(_ event: Event) {
        addressLabel.text = "\(event.location.address)\n\(event.location.city), \(event.location.state)\n\(event.location.zipCode)"
        //        streetNumberLabel.text = event.location.address
        //        cityStateLabel.text = "\(event.location.city), \(event.location.state)"
        //        zipcodeLabel.text = event.location.zipCode
    }
}
