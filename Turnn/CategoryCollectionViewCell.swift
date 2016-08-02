//
//  CategoryCollectionViewCell.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        
        categoryImageView.layer.cornerRadius = categoryImageView.bounds.width / 2
    }
    
}
