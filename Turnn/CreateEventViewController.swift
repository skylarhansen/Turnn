//
//  ViewController.swift
//  PracticeCreateEvent
//
//  Created by Justin Smith on 8/2/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit

class CreateEventViewController: UITableViewController {
    
    var locationSelected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTableViewUI()
    }
    
    func setupTableViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.278, green: 0.310, blue: 0.310, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)
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
            return 9
        } else {
            return 6
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if locationSelected {
            switch indexPath.row {
            case 0:
                let titleCell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as? TitleTableViewCell
                return titleCell ?? UITableViewCell()
            case 1:
                let timeCell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as? TimeTableViewCell
                return timeCell ?? UITableViewCell()
            case 2:
                let locationCell = tableView.dequeueReusableCellWithIdentifier("locationTitleCell", forIndexPath: indexPath) as? LocationTableViewCell
                return locationCell ?? UITableViewCell()
            case 3:
                let addressCell = tableView.dequeueReusableCellWithIdentifier("addressCell", forIndexPath: indexPath) as? AddressTableViewCell
                return addressCell ?? UITableViewCell()
            case 4:
                let cityCell = tableView.dequeueReusableCellWithIdentifier("cityCell", forIndexPath: indexPath) as? CityTableViewCell
                return cityCell ?? UITableViewCell()
            case 5:
                let zipCell = tableView.dequeueReusableCellWithIdentifier("zipCell", forIndexPath: indexPath) as? ZipTableViewCell
                return zipCell ?? UITableViewCell()
            case 6:
                let descriptionCell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as? DescriptionTableViewCell
                return descriptionCell ?? UITableViewCell()
            case 7:
                let moreInfoCell = tableView.dequeueReusableCellWithIdentifier("moreInfoCell", forIndexPath: indexPath) as? MoreInfoTableViewCell
                return moreInfoCell ?? UITableViewCell()
            case 8:
                let categoriesCell = tableView.dequeueReusableCellWithIdentifier("categoriesCell", forIndexPath: indexPath) as? CategoriesTableViewCell
                return categoriesCell ?? UITableViewCell()
            default:
                return UITableViewCell()
            }
        } else {
            switch indexPath.row {
            case 0:
                let titleCell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as? TitleTableViewCell
                return titleCell ?? UITableViewCell()
            case 1:
                let timeCell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as? TimeTableViewCell
                return timeCell ?? UITableViewCell()
            case 2:
                let locationCell = tableView.dequeueReusableCellWithIdentifier("locationTitleCell", forIndexPath: indexPath) as? LocationTableViewCell
                return locationCell ?? UITableViewCell()
            case 3:
                let descriptionCell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as? DescriptionTableViewCell
                return descriptionCell ?? UITableViewCell()
            case 4:
                let moreInfoCell = tableView.dequeueReusableCellWithIdentifier("moreInfoCell", forIndexPath: indexPath) as? MoreInfoTableViewCell
                return moreInfoCell ?? UITableViewCell()
            case 5:
                let categoriesCell = tableView.dequeueReusableCellWithIdentifier("categoriesCell", forIndexPath: indexPath) as? CategoriesTableViewCell
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
        if indexPath.row == 2 && !self.locationSelected {
            self.locationSelected = !self.locationSelected
            tableView.beginUpdates()
            let indexPaths = [NSIndexPath(forRow: 3, inSection: 0), NSIndexPath(forRow: 4, inSection: 0), NSIndexPath(forRow: 5, inSection: 0)]
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Middle)
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if locationSelected {
            switch indexPath.row {
            case 6...7:
                return 120
            case 8:
                return 200
            default:
                return 50
            }
        } else {
            switch indexPath.row {
            case 3...4:
                return 120
            case 5:
                return 200
            default:
                return 50
            }
        }
    }
    
    
}

