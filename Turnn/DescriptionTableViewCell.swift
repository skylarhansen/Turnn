//
//  DescriptionTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak fileprivate var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.delegate = self
        descriptionTextView.text = " Briefly describe your event"
        descriptionTextView.textColor = UIColor.gray
        setupCell()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.gray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
        textView.layer.borderWidth = 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text!.characters.count + text.characters.count - range.length
        if textView == descriptionTextView {
            return newLength <= 175
        }
        return true
    }
    
    func setupCell() {
        self.backgroundColor = .clear
        self.descriptionTextView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.backgroundColor = .clear
            }) 
        }
    }
}
