//
//  MyEventsTableViewController.swift
//  Turnn
//
//  Created by Justin Smith on 8/18/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class MyEventsTableViewController: UITableViewController {
    
    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        EventController.fetchEventsForUserID(UserController.shared.currentUserId) { (events) in
            if let events = events {
                self.events = events
                self.tableView.reloadData()
            } else {
                print("EVENTS IS NIL")
            }
        }
        
        setupTableViewUI()
    }
    
    @IBAction func logOutButtonTapped() {
        print("logged out tapped")
        UserController.logOutUser()
        self.performSegueWithIdentifier("logOutSegue", sender: self)
    }
    
    @IBAction func doneButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupTableViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.turnnGray()
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
        self.tableView.separatorColor = .clearColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        setBackgroundForTableView()
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("myEventCell", forIndexPath: indexPath) as? MyEventTableViewCell {
            let event = events[indexPath.row]
            cell.updateWithEvent(event)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let event = EventController.sharedController.events[indexPath.row]
            EventController.sharedController.deleteEvent(event)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }
}