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
    
    @IBOutlet weak fileprivate var categoriesView: UIView!
    @IBOutlet fileprivate var categoryImageViews: [UIImageView]!
    @IBOutlet weak fileprivate var addCategoriesButton: UIButton!
    
    weak var imagesSetDelegate: ImagesSetDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func loadImageViews(_ images: [UIImage], completion: (_ success: Bool) -> Void) {
        for (index, image) in images.enumerated() {
            categoryImageViews[index].isHidden = false
            categoryImageViews[index].image = image
        }
    }
    
    func loadCategoriesForEvent(_ categories: [Int]) -> [UIImage] {
        var imageArray: [UIImage] = []
        for category in categories {
            if let image = Categories(rawValue: category)?.selectedImage {
                imageArray.append(image)
            }
        }
        return imageArray
    }
    
    func updateWith(_ categories: [Int]) {
        if categories.count > 0 {
            addCategoriesButton.setTitle("Edit Categories", for: UIControlState())
            for imageView in categoryImageViews {
                imageView.isHidden = true
            }
            self.categoriesView.isHidden = false
            loadImageViews(loadCategoriesForEvent(categories)) { _ in
            }
        }
    }
    
    func setupCell() {
        self.backgroundColor = .clear
        self.categoriesView.layer.cornerRadius = 8
        self.categoriesView.isHidden = true
        self.categoriesView.backgroundColor = UIColor.turnnGray().withAlphaComponent(0.8)
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
