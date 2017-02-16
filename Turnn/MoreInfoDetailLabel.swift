//
//  MoreInfoDetailLabel.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/15/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class MoreInfoDetailLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
    }
}
