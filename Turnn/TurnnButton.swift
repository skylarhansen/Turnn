//
//  TurnnButton.swift
//  Turnn
//
//  Created by Justin Smith on 8/11/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

@IBDesignable
class TurnnButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet {
        setupView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
        setupView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        self.layer.borderColor = UIColor.turnnWhite().CGColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}