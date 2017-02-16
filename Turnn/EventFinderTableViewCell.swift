//
//  EventFinderTableViewCell.swift
//  Turnn
//
//  Created by Tyler on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class EventFinderTableViewCell: UITableViewCell {
    
    @IBOutlet weak fileprivate var eventNameLabel: UILabel!
    @IBOutlet fileprivate var categoryImages: [UIImageView]!
    
    func loadImageViews(_ images: [UIImage]) {
        for (index, image) in images.enumerated() {
            categoryImages[index].isHidden = false
            categoryImages[index].image = image
        }
    }
    
    func updateWithEvent(_ event: Event) {
        eventNameLabel.text = event.title
        for categoryImageView in categoryImages {
            categoryImageView.isHidden = true
        }
        loadImageViews(event.loadCategoriesForEvent())
    }

    override func awakeFromNib() {
        super.awakeFromNib()
           for categoryImageView in categoryImages {
            categoryImageView.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
  
        if selected == true {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.backgroundColor = .clear
            }) 
        }
    }
}
