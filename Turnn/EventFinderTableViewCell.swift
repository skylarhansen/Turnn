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
    @IBOutlet var categoryImages: [UIImageView]!
    
    func loadImageViews(images: [UIImage]) {
        for (index, image) in images.enumerate() {
            categoryImages[index].hidden = false
            categoryImages[index].image = image
        }
    }
    
    func updateWithEvent(event: Event) {
        eventNameLabel.text = event.title
        loadImageViews(event.loadCategoriesForEvent())
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        for categoyImageView in categoryImages {
            categoyImageView.hidden = true
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        if selected == true {
            self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
            
            UIView.animateWithDuration(0.5) {
                self.backgroundColor = .clearColor()
            }
        }
    }
}
