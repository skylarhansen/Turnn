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
    
    var doneButtonTitle = "Search"
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.doneButton.title = doneButtonTitle
        
        collectionView?.allowsMultipleSelection = true
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier("unwindWithCategories", sender: self)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Categories.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? CategoryCollectionViewCell ?? CategoryCollectionViewCell()
        guard let category = Categories(rawValue: indexPath.item),
            image = category.image,
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
        
        if let count = collectionView.indexPathsForSelectedItems()?.count {
            
            self.title = "\(count)/5 Selected"
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell {
            
            guard let category = Categories(rawValue: indexPath.item),
                image = category.image,
                name = category.name else { return }
            
            cell.updateWith(image, name: name)
        }
        
        if let count = collectionView.indexPathsForSelectedItems()?.count {
            
            self.title = "\(count)/5 Selected"
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