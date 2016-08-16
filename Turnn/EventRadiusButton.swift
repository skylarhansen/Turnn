//
//  EventRadiusButton.swift
//  Turnn
//
//  Created by Justin Smith on 8/15/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class EventRadiusButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        self.makeCircular()
        self.backgroundColor = UIColor.turnnGray().colorWithAlphaComponent(0.9)
        self.setTitleColor(UIColor.turnnBlue(), forState: .Normal)
    }
}
