//
//  EventDetailViewController.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import Mapbox

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate {
    
    var event: Event?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    //@IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventEndTimeLabel: UILabel!
    @IBOutlet var categoryImageViews: [UIImageView]!
    @IBOutlet weak var categoryImageHolderView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        
        visualEffectView.frame = self.view.bounds
        
        backgroundImageView.addSubview(visualEffectView)
        
        let visualEffectView2 = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        
        visualEffectView2.frame = self.view.bounds
        
        eventImageView.addSubview(visualEffectView2)
        
        mapImageView.layer.borderWidth = 3
        mapImageView.layer.borderColor = UIColor.blackColor().CGColor
        mapImageView.layer.masksToBounds = false
        mapImageView.layer.cornerRadius = mapImageView.frame.width/2
        mapImageView.clipsToBounds = true
        
//        let point = MGLPointAnnotation()
//        point.coordinate = CLLocationCoordinate2D(latitude: 40.761823, longitude: -111.890594)
//        point.title = "Dev Mountain"
//        point.subtitle = "341 Main St Salt Lake City, U.S.A"
//        
//        mapView.addAnnotation(point)
//        
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
        //eventImageView.image = event.image
        eventTitleLabel.text = event.title
        eventTimeLabel.text = "\(event.startTime.dateFormat())"
        loadImageViews(event.loadCategoriesForEvent())
        if event.endTime == event.endTime {
            eventTimeLabel.text = "\(event.endTime.dateFormat())" } else {
            eventEndTimeLabel.text = "" }
    }
    
    // MARK: - Action Buttons -
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func locationButtonTapped(sender: AnyObject) {
        presentAlertController()
    }
    // MARK: - Alert Controller
    func presentAlertController() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let mapsAction = UIAlertAction(title: "Maps", style: .Default) { (_) in
            guard let latitude = self.event?.location.latitude, let longitude = self.event?.location.latitude else {
                return
            }
            
            let url = NSURL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=w")!
            UIApplication.sharedApplication().openURL(url)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(mapsAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
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
            locationDetailCell?.streetNumberLabel.text = event?.location.address
            locationDetailCell?.cityStateLabel.text = "\(event!.location.city), \(event!.location.state)"
            locationDetailCell?.zipcodeLabel.text = event?.location.zipCode
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
}