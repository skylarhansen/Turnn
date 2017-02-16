//
//  CategoryCollectionViewController.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


private let reuseIdentifier = "categoryCell"

class CategoryCollectionViewController: UICollectionViewController {
    
    var doneButtonTitle = "Search"
    var categories: [Int] = []
    
    enum ButtonMode: String {
        case Search
        case Save
    }
    
    var mode: ButtonMode = .Save
    
    @IBOutlet weak fileprivate var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        handleMode()
        setUpNavigationUI()
        
        collectionView?.allowsMultipleSelection = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCreateEvent" {
            if let createEventVC = segue.destination as? CreateEventViewController {
                createEventVC.categories = self.categories
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        
        if mode == .Search {
            self.performSegue(withIdentifier: "unwindToEventFinder", sender: self)
        } else if mode == .Save {
            self.performSegue(withIdentifier: "unwindToCreateEvent", sender: self)
            
        }
    }
    
    func handleMode() {
        doneButton.title = mode.rawValue
    }
    
    func setUpNavigationUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.278, green: 0.310, blue: 0.310, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell ?? CategoryCollectionViewCell()
        guard let category = Categories(rawValue: indexPath.item),
            let image = category.grayCircleImage,
            let name = category.name else { return CategoryCollectionViewCell() }
        
        cell.updateWith(image, name: name)
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard collectionView.indexPathsForSelectedItems?.count <= 5 else {
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            
            guard let category = Categories(rawValue: indexPath.item),
                let selectedImage = category.selectedCircleImage,
                let name = category.name else { return }
            
            cell.updateWith(selectedImage, name: name)
            categories.append(category.rawValue)
        }
        
        if let count = collectionView.indexPathsForSelectedItems?.count {
            
            self.title = "\(count)/5 Selected"
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            
            guard let category = Categories(rawValue: indexPath.item),
                let image = category.grayCircleImage,
                let name = category.name,
                let index = categories.index(of: category.rawValue) else { return }
            
            cell.updateWith(image, name: name)
            categories.remove(at: index)
        }
        
        if let count = collectionView.indexPathsForSelectedItems?.count {
            
            self.title = "\(count)/5 Selected"
        }
    }
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 86, height: 107)
    }
}
