//
//  DescriptionTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.delegate = self
        descriptionTextView.text = " Briefly describe your event"
        descriptionTextView.textColor = UIColor.grayColor()
        setupCell()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if descriptionTextView.textColor == UIColor.grayColor() {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.blackColor()
        }
        textView.layer.borderWidth = 0
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text!.characters.count + text.characters.count - range.length
        if textView == descriptionTextView {
            return newLength <= 175
        }
        return true
    }
    
    func setupCell() {
        self.backgroundColor = .clearColor()
        self.descriptionTextView.layer.cornerRadius = 8
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
