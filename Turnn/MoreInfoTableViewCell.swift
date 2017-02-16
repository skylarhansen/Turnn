//
//  MoreInfoTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class MoreInfoTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak fileprivate var moreInfoLabel: UILabel!
    @IBOutlet weak var moreInfoTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        moreInfoTextView.delegate = self
        moreInfoTextView.text = " If needed, explain what to bring, what to wear, etc."
        moreInfoTextView.textColor = UIColor.gray
        setupCell()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if moreInfoTextView.textColor == UIColor.gray {
            moreInfoTextView.text = nil
            moreInfoTextView.textColor = UIColor.black
        }
        textView.layer.borderWidth = 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text!.characters.count + text.characters.count - range.length
        if textView == moreInfoTextView {
            return newLength <= 175
        }
        return true
    }
    
    func setupCell() {
        self.backgroundColor = .clear
        self.moreInfoTextView.layer.cornerRadius = 8
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
