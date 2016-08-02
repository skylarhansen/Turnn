//
//  ExampleCollectionViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 35.0 / 2.0
    }
    
}
