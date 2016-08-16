//
//  LogOutView.swift
//  Turnn
//
//  Created by Justin Smith on 8/15/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class LogOutView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    
    func setupView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.turnnGray()
        self.alpha = 0.0
    }
}
