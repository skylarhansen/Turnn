//
//  ViewController.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CreateEventViewController: UITableViewController {
    
    var locationSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewUI()
    }
    
    var titleCell: TitleTableViewCell!
    var timeCell: TimeTableViewCell!
    var endTimeCell: EndTimeTableViewCell!
    var locationCell: LocationTableViewCell!
    var addressCell: AddressTableViewCell!
    var cityCell: CityTableViewCell!
    var descriptionCell: DescriptionTableViewCell!
    var zipCell: ZipTableViewCell!
    var moreInfoCell: MoreInfoTableViewCell!
    var stateCell: StateTableViewCell!
    var location: Location!
    
    var categories: [Int]? {
        didSet {
            if locationSelected {
                let indexPath = NSIndexPath(forRow: 10, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            } else {
                let indexPath = NSIndexPath(forRow: 6, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createEventButtonTapped(sender: AnyObject) {
        createEventWithEventInfo { (success) in
            self.dismissViewControllerAnimated(true, completion: nil)
            if !success {
                let alertController = UIAlertController(title: "Missing Required Information", message: "Double check your event's required fields!", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okie dokes", style: .Cancel, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToCreateEvent(segue: UIStoryboardSegue) {
        
    }
    
    func createEventWithEventInfo(completion: (success: Bool) -> Void) {
        if let title = titleCell.titleTextField.text where title.characters.count > 0 , let _ = timeCell.timeTextField.text, let _ = endTimeCell.endTimeTextField.text, let address = addressCell.addressTextField.text where address.characters.count > 0, let city = cityCell.cityTextField.text, let zip = zipCell.zipTextField.text, let description = descriptionCell.descriptionTextView.text, let moreInfo = moreInfoCell.moreInfoTextView.text, let categories = categories, let state = stateCell.stateTextField.text {
            
            location = Location(address: address, city: city, state: state, zipCode: zip)
            
            EventController.createSnapShotOfLocation(location) { (success, image) in
                if success && image != nil {
                    EventController.createEvent(title, location: self.location, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(1500), categories: categories, eventDescription: description, passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: UserController.shared.currentUser!, moreInfo: moreInfo, completion: { (success) in
                        if success {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    })
                }
            }
            
        } else {
            print("So Sorry, could not create Event because something was nil")
            completion(success: false)
        }
    }
    
    func setupTableViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.turnnGray()
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
        self.tableView.separatorColor = .clearColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        setBackgroundForTableView()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setBackgroundForTableView() {
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        let imageView = UIImageView(image: UIImage(named: "Turnn Background")!)
        imageView.contentMode = .Center
        
        imageView.addSubview(blurView)
        tableView.backgroundView = imageView
        blurView.frame = imageView.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - TableView Datasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locationSelected {
            return 11
        } else {
            return 7
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if locationSelected {
            switch indexPath.row {
            case 0:
                titleCell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as? TitleTableViewCell
                return titleCell ?? UITableViewCell()
            case 1:
                timeCell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as? TimeTableViewCell
                return timeCell ?? UITableViewCell()
            case 2:
                endTimeCell = tableView.dequeueReusableCellWithIdentifier("endTimeCell", forIndexPath: indexPath) as? EndTimeTableViewCell
                return endTimeCell ?? UITableViewCell()
            case 3:
                locationCell = tableView.dequeueReusableCellWithIdentifier("locationTitleCell", forIndexPath: indexPath) as? LocationTableViewCell
                return locationCell ?? UITableViewCell()
            case 4:
                addressCell = tableView.dequeueReusableCellWithIdentifier("addressCell", forIndexPath: indexPath) as? AddressTableViewCell
                return addressCell ?? UITableViewCell()
            case 5:
                cityCell = tableView.dequeueReusableCellWithIdentifier("cityCell", forIndexPath: indexPath) as? CityTableViewCell
                return cityCell ?? UITableViewCell()
            case 6:
                stateCell = tableView.dequeueReusableCellWithIdentifier("stateCell", forIndexPath: indexPath) as? StateTableViewCell
                return stateCell ?? UITableViewCell()
            case 7:
                zipCell = tableView.dequeueReusableCellWithIdentifier("zipCell", forIndexPath: indexPath) as? ZipTableViewCell
                return zipCell ?? UITableViewCell()
            case 8:
                descriptionCell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as? DescriptionTableViewCell
                return descriptionCell ?? UITableViewCell()
            case 9:
                moreInfoCell = tableView.dequeueReusableCellWithIdentifier("moreInfoCell", forIndexPath: indexPath) as? MoreInfoTableViewCell
                return moreInfoCell ?? UITableViewCell()
            case 10:
                let categoriesCell = tableView.dequeueReusableCellWithIdentifier("categoriesCell", forIndexPath: indexPath) as? CategoriesTableViewCell
                if let categories = categories {
                    categoriesCell?.updateWith(categories)
                }
                return categoriesCell ?? UITableViewCell()
            default:
                return UITableViewCell()
            }
        } else {
            switch indexPath.row {
            case 0:
                titleCell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as? TitleTableViewCell
                return titleCell ?? UITableViewCell()
            case 1:
                timeCell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as? TimeTableViewCell
                return timeCell ?? UITableViewCell()
            case 2:
                endTimeCell = tableView.dequeueReusableCellWithIdentifier("endTimeCell", forIndexPath: indexPath) as? EndTimeTableViewCell
                return endTimeCell ?? UITableViewCell()
            case 3:
                locationCell = tableView.dequeueReusableCellWithIdentifier("locationTitleCell", forIndexPath: indexPath) as? LocationTableViewCell
                return locationCell ?? UITableViewCell()
            case 4:
                descriptionCell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as? DescriptionTableViewCell
                return descriptionCell ?? UITableViewCell()
            case 5:
                moreInfoCell = tableView.dequeueReusableCellWithIdentifier("moreInfoCell", forIndexPath: indexPath) as? MoreInfoTableViewCell
                return moreInfoCell ?? UITableViewCell()
            case 6:
                let categoriesCell = tableView.dequeueReusableCellWithIdentifier("categoriesCell", forIndexPath: indexPath) as? CategoriesTableViewCell
                if let categories = categories {
                    categoriesCell?.updateWith(categories)
                }
                return categoriesCell ?? UITableViewCell()
            default:
                return UITableViewCell()
            }
        }
    }
    
    // MARK - TableView Delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // May not need
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 && !self.locationSelected {
            self.locationSelected = !self.locationSelected
            tableView.beginUpdates()
            let indexPaths = [NSIndexPath(forRow: 4, inSection: 0), NSIndexPath(forRow: 5, inSection: 0), NSIndexPath(forRow: 6, inSection: 0), NSIndexPath(forRow: 7, inSection: 0)]
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Middle)
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if locationSelected {
            switch indexPath.row {
            case 8...9:
                return 120
            case 10:
                return 100
            default:
                return 50
            }
        } else {
            switch indexPath.row {
            case 4...5:
                return 120
            case 6:
                return 100
            default:
                return 50
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addCategories" {
            let navController = segue.destinationViewController as? UINavigationController
            let categoryVC = navController?.viewControllers.first as? CategoryCollectionViewController
            categoryVC?.mode = .Save
        }
    }
}

