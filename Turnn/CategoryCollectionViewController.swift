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
    var categories: [Int] = []
    
    enum ButtonMode: String {
        case Search
        case Save
    }
    
    var mode: ButtonMode = .Save
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        handleMode()
        setUpNavigationUI()
        
        collectionView?.allowsMultipleSelection = true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToCreateEvent" {
            if let createEventVC = segue.destinationViewController as? CreateEventViewController {
                createEventVC.categories = self.categories
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        if mode == .Search {
            self.performSegueWithIdentifier("unwindToEventFinder", sender: self)
        } else if mode == .Save {
            self.performSegueWithIdentifier("unwindToCreateEvent", sender: self)
            
        }
    }
    
    func handleMode() {
        doneButton.title = mode.rawValue
    }
    
    func setUpNavigationUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.278, green: 0.310, blue: 0.310, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Categories.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? CategoryCollectionViewCell ?? CategoryCollectionViewCell()
        guard let category = Categories(rawValue: indexPath.item),
            image = category.grayCircleImage,
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
            categories.append(category.rawValue)
        }
        
        if let count = collectionView.indexPathsForSelectedItems()?.count {
            
            self.title = "\(count)/5 Selected"
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell {
            
            guard let category = Categories(rawValue: indexPath.item),
                image = category.grayCircleImage,
                name = category.name,
                index = categories.indexOf(category.rawValue) else { return }
            
            cell.updateWith(image, name: name)
            categories.removeAtIndex(index)
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