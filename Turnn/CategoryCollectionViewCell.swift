//
//  CategoryCollectionViewCell.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var categoryImageView: UIImageView!
    @IBOutlet weak private var categoryLabel: UILabel!
    
    var name: String = ""
    
    override func awakeFromNib() {
        
        categoryImageView.layer.masksToBounds = true
    }
    
    func updateWith(image: UIImage, name: String) {
        
        categoryImageView.image = image
        categoryLabel.text = name
    }
}
