//
//  MoreInfoTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class MoreInfoTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak private var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        moreInfoTextView.delegate = self
        moreInfoTextView.text = " If needed, explain what to bring, what to wear, etc."
        moreInfoTextView.textColor = UIColor.grayColor()
        setupCell()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if moreInfoTextView.textColor == UIColor.grayColor() {
            moreInfoTextView.text = nil
            moreInfoTextView.textColor = UIColor.blackColor()
        }
        textView.layer.borderWidth = 0
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text!.characters.count + text.characters.count - range.length
        if textView == moreInfoTextView {
            return newLength <= 175
        }
        return true
    }

    
    func setupCell() {
        self.backgroundColor = .clearColor()
        self.moreInfoTextView.layer.cornerRadius = 8
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true {
            self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
            
            UIView.animateWithDuration(0.5) {
                self.backgroundColor = .clearColor()
            }
        }
    }
}

