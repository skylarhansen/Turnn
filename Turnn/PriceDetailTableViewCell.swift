//
//  PriceDetailTableViewCell.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class PriceDetailTableViewCell: UITableViewCell {
    
    var price: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak fileprivate var priceLabel: UILabel!
    @IBOutlet weak var priceNumberLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updatePriceWithEvent(_ event: Event) {
        guard price != nil else { return }
            priceNumberLabel.text = "\(String(describing: event.price))"
        }

}
