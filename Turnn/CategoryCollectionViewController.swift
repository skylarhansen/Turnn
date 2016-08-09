//
//  CategoryCollectionViewController.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "categoryCell"

class CategoryCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        collectionView?.allowsMultipleSelection = true
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
}
   
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Categories.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? CategoryCollectionViewCell ?? CategoryCollectionViewCell()
        guard let category = Categories(rawValue: indexPath.item),
<<<<<<< Updated upstream
<<<<<<< Updated upstream
            image = category.grayCircleImage,
=======
            image = category.image,
>>>>>>> Stashed changes
=======
            image = category.image,
>>>>>>> Stashed changes
            name = category.name else { return CategoryCollectionViewCell() }
        
        cell.updateWith(image, name: name)
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard collectionView.indexPathsForSelectedItems()?.count <= 5 else {
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
            return
        }
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell {
            
            guard let category = Categories(rawValue: indexPath.item),
                selectedImage = category.selectedCircleImage,
                name = category.name else { return }
            
            cell.updateWith(selectedImage, name: name)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell {
            
            guard let category = Categories(rawValue: indexPath.item),
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                image = category.grayCircleImage,
=======
                image = category.image,
>>>>>>> Stashed changes
=======
                image = category.image,
>>>>>>> Stashed changes
                name = category.name else { return }
            
            cell.updateWith(image, name: name)
        }
    }
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(86, 107)
    }
}