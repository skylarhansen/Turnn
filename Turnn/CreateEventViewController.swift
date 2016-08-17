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
            if !success {
                
            }
        }
    }
    
    
    func createAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func createEventWithEventInfo(completion: (success: Bool) -> Void) {
        if locationSelected {
            if let title = titleCell.titleTextField.text where title.characters.count > 0 {
                if let startTime = timeCell.date {
                    if let endTime = endTimeCell.date {
                        if let address = addressCell.addressTextField.text where address.characters.count > 0 {
                            if let city = cityCell.cityTextField.text where cityCell.cityTextField.text != "" {
                                if let zip = zipCell.zipTextField.text where zipCell.zipTextField.text != "" {
                                    if let categories = categories {
                                        if let state = stateCell.stateTextField.text where stateCell.stateTextField.text != "" {
                                            location = Location(address: address, city: city, state: state, zipCode: zip)
                                            
                                            EventController.createSnapShotOfLocation(location) { (success, image) in
                                                if success && image != nil {
                                                    EventController.createEvent(title, location: self.location, startTime: startTime, endTime: endTime, categories: categories, eventDescription: self.descriptionCell.descriptionTextView.text ?? "", passwordProtected: false, password: nil, price: nil, contactInfo: nil, image: nil, host: UserController.shared.currentUser!, moreInfo: self.moreInfoCell.moreInfoTextView.text ?? "", completion: { (success) in
                                                        if success {
                                                            self.dismissViewControllerAnimated(true, completion: nil)
                                                        }
                                                    })
                                                }
                                            }
                                        } else {
                                            createAlert("Missing State", message: "Please be sure to include the state as part of your address")
                                            hightlightTextFieldForError(self.stateCell.stateTextField)
                                        }
                                    } else {
                                        createAlert("Missing Categories", message: "Please be sure to inclue at least one category for your event")
                                    }
                                } else {
                                    createAlert("Missing Zip", message: "Please be sure to include the zip as part of your address")
                                    hightlightTextFieldForError(self.zipCell.zipTextField)
                                }
                            } else {
                                createAlert("Missing City", message: "Please be sure to include the city as part of your address")
                                hightlightTextFieldForError(self.cityCell.cityTextField)
                            }
                        } else {
                            createAlert("Missing Address", message: "Please be sure to include an address for the event")
                            hightlightTextFieldForError(self.addressCell.addressTextField)
                        }
                    } else {
                        createAlert("No End Date", message: "Please enter a end date for your event")
                        hightlightTextFieldForError(self.endTimeCell.endTimeTextField)
                    }
                } else {
                    createAlert("No Start Date", message: "Please enter a starting date for your event")
                    hightlightTextFieldForError(self.timeCell.timeTextField)
                }
            } else {
                createAlert("No Title", message: "Please enter a title for your event")
                hightlightTextFieldForError(self.titleCell.titleTextField)
            }
        } else {
            createAlert("Event Location", message: "Please be sure to include a location by tapping on \"Location\" and completing the required fields")
        }
    }
    
    func hightlightTextFieldForError(textfield: UITextField) {
        textfield.layer.borderWidth = 1.5
        textfield.layer.borderColor = UIColor.error().CGColor
        textfield.layer.cornerRadius = 4
        textfield.layer.masksToBounds = true
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.4
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -2.0, 2.0, 0.0 ]
        textfield.layer.addAnimation(animation, forKey: "shake")
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

