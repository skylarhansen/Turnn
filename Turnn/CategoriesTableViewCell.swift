//
//  CategoriesTableViewCell.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

protocol ImagesSetDelegate: class {
    func imagesSet()
}

class CategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet var categoryImageViews: [UIImageView]!
    @IBOutlet weak var addCategoriesButton: UIButton!
    
    weak var imagesSetDelegate: ImagesSetDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        setupCell()
    }
    
    func loadImageViews(images: [UIImage], completion: (success: Bool) -> Void) {
        for (index, image) in images.enumerate() {
            categoryImageViews[index].hidden = false
            categoryImageViews[index].image = image
        }
    }
    
    func loadCategoriesForEvent(categories: [Int]) -> [UIImage] {
        var imageArray: [UIImage] = []
        for category in categories {
            if let image = Categories(rawValue: category)?.selectedImage {
                imageArray.append(image)
            }
        }
        return imageArray
    }
    
    func updateWith(categories: [Int]) {
        if categories.count > 0 {
            addCategoriesButton.setTitle("Edit Categories", forState: .Normal)
            for imageView in categoryImageViews {
                imageView.hidden = true
            }
            self.categoriesView.hidden = false
            loadImageViews(loadCategoriesForEvent(categories)) { _ in
            }
        }
    }
    
    func setupCell() {
        self.backgroundColor = .clearColor()
        self.categoriesView.layer.cornerRadius = 8
        self.categoriesView.hidden = true
        self.categoriesView.backgroundColor = UIColor.turnnGray().colorWithAlphaComponent(0.8)
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