//
//  NoResultsView.swift
//  Turnn
//
//  Created by Steve Cox on 8/31/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class NoResultsView: UIView {
    
    let eventFinderViewController = EventFinderViewController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        self.alpha = 0
        self.backgroundColor = .clearColor()
    }
}