//
//  EventDetailViewController.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, MFMailComposeViewControllerDelegate {
    
    var event: Event?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet var categoryImageViews: [UIImageView]!
    @IBOutlet weak var categoryImageHolderView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        
        visualEffectView.frame = self.view.bounds
        
        backgroundImageView.addSubview(visualEffectView)
        
        mapButton.layer.borderWidth = 3
        mapButton.layer.borderColor = UIColor.blackColor().CGColor
        mapButton.layer.masksToBounds = false
        mapButton.layer.cornerRadius = mapButton.frame.width/2
        mapButton.clipsToBounds = true
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        categoryImageHolderView.backgroundColor = UIColor.turnnGray()
        
        for imageView in categoryImageViews {
            imageView.hidden = true
        }
        
        if let event = event {
            updateEventDetail(event)
        }
        
        let string = NSAttributedString(string: "Back to Events", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)])
        backButton.setAttributedTitle(string, forState: .Normal)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
    }
    
    func loadImageViews(images: [UIImage]) {
        for (index, image) in images.enumerate() {
            categoryImageViews[index].hidden = false
            categoryImageViews[index].image = image
        }
    }
    
    func updateEventDetail(event: Event) {
        
        eventTitleLabel.text = event.title
        eventTimeLabel.text = "\(event.startTime.dateFormat()) - \(event.endTime.dateFormat())"
        loadImageViews(event.loadCategoriesForEvent())
        
        if event.startTime.dateOnly() == event.endTime.dateOnly() {
            eventDateLabel.text = event.startTime.dateOnly()
        } else {
            eventDateLabel.text = "\(event.startTime.dateOnly()) - \(event.endTime.dateOnly())"
        }
        
        ImageController.imageForUrl(event.imageURL!) { (image) in
            self.mapButton.setBackgroundImage(image, forState: .Normal)
        }
    }
    
    // MARK: - Action Buttons -
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
//    @IBAction func locationButtonTapped(sender: AnyObject) {
//        presentAlertController()
//    }
    // MARK: - Alert Controller
//    func presentAlertController() {
//        
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//        let mapsAction = UIAlertAction(title: "Maps", style: .Default) { (_) in
//            guard let latitude = self.event?.location.latitude, let longitude = self.event?.location.latitude else {
//                return
//            }
//            
//            let url = NSURL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=w")!
//            UIApplication.sharedApplication().openURL(url)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        actionSheet.addAction(mapsAction)
//        actionSheet.addAction(cancelAction)
//        
//        presentViewController(actionSheet, animated: true, completion: nil)
//    }
    
    // MARK: - tableView data source functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            let hostDetailCell = tableView.dequeueReusableCellWithIdentifier("hostDetailCell", forIndexPath: indexPath) as? HostDetailTableViewCell
            hostDetailCell?.hostNameLabel.text = (event?.host.firstName)! + " " + (event?.host.lastName)!
            return hostDetailCell ?? UITableViewCell()
            
        case 1:
            let locationDetailCell =  tableView.dequeueReusableCellWithIdentifier("locationDetailCell", forIndexPath: indexPath) as? LocationDetailTableViewCell
            locationDetailCell?.updateLocationWithEvent(event!)
//            locationDetailCell?.streetNumberLabel.text = event?.location.address
//            locationDetailCell?.cityStateLabel.text = "\(event!.location.city), \(event!.location.state)"
//            locationDetailCell?.zipcodeLabel.text = event?.location.zipCode
            return locationDetailCell ?? UITableViewCell()
            
        case 2:
            let priceDetailCell = tableView.dequeueReusableCellWithIdentifier("priceDetailCell", forIndexPath: indexPath) as? PriceDetailTableViewCell
            if let price = event?.price {
                priceDetailCell?.priceNumberLabel.text = "$\(price)"
            } else {
                priceDetailCell?.priceNumberLabel.text = "Free"
            }
            return priceDetailCell ?? UITableViewCell()
            
            
        case 3:
            let descriptionDetailCell = tableView.dequeueReusableCellWithIdentifier("descriptionDetailCell", forIndexPath: indexPath) as? DescriptionDetailTableViewCell
            descriptionDetailCell?.detailedDescriptionLabel.text = event?.eventDescription
            return descriptionDetailCell ?? UITableViewCell()
            
        case 4:
            let moreInfoDetailCell =  tableView.dequeueReusableCellWithIdentifier("moreInfoDetailCell", forIndexPath: indexPath) as? MoreInfoDetailTableViewCell
            moreInfoDetailCell?.moreInfoDetailLabel.text = event?.eventDescription
            return moreInfoDetailCell ?? UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - REPORTING, outlet is currently disconnected, ALSO
    // DO NOT USE WITH MOCK DATA, our mock data events don't have identifiers,
    // it will cause a crash. can leave optional but then it will
    // print odd text in email report when we use the REAL DATA
    
    @IBAction func reportButtonTapped(sender: AnyObject) {
        reportEvent()
    }
    
    func showSendMailErrorAlert(){
        let sendMailErrorAlert =
            UIAlertController(title: "Couldn't Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel){ (action) in print(action)}
        sendMailErrorAlert.addAction(dismissAction)
        self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reportEvent(){
        if event != nil {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "Report event as inappropriate", style: .Destructive) { action in
                
                if MFMailComposeViewController.canSendMail() {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    composeVC.setToRecipients(["report@honestbadger.com"])
                    composeVC.setSubject("Inappropriate Event Report")
                    composeVC.setMessageBody("Event to report:\n'\(self.event!.title)'\n\n Thank you for your report! Do you have any comments to add?: \n\n\n\n\n\n\n \n*******************\nDeveloper Data:\neid\(self.event!.identifier!)\nuid:\(self.event!.host.identifier!)\nst:\(self.event!.startTime.timeIntervalSince1970)\n*******************", isHTML: false)
                    
                    self.presentViewController(composeVC, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
                
                })
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
                })
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}