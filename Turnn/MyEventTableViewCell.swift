//
//  MyEventTableViewCell.swift
//  Turnn
//
//  Created by Justin Smith on 8/18/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class MyEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak fileprivate var eventTitleLabel: UILabel!
    @IBOutlet weak fileprivate var eventDateTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell() {
        self.backgroundColor = .clear
    }
    
    func updateWithEvent(_ event: Event) {
        eventTitleLabel.text = "• \(event.title)"
        eventDateTitleLabel.text =  "  \(event.startTime.dateLongFormat())"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.backgroundColor = .clear
            }) 
        }
    }
}
