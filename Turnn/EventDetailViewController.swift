//
//  EventDetailViewController.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import Mapbox

class EventDetailViewController: UIViewController, MGLMapViewDelegate {
    
    var event: Event?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventEndTimeLabel: UILabel!
    @IBOutlet var categoryImageViews: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        
        visualEffectView.frame = backgroundImageView.bounds
        
        backgroundImageView.addSubview(visualEffectView)
        
        let visualEffectView2 = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        
        visualEffectView2.frame = eventImageView.bounds
        
        eventImageView.addSubview(visualEffectView2)
        
        mapView.layer.borderWidth = 3
        mapView.layer.borderColor = UIColor.blackColor().CGColor
        mapView.layer.masksToBounds = false
        mapView.layer.cornerRadius = mapView.frame.width/2
        mapView.clipsToBounds = true
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 40.761823, longitude: -111.890594)
        point.title = "Dev Mountain"
        point.subtitle = "341 Main St Salt Lake City, U.S.A"
        
        mapView.addAnnotation(point)
    }
    
    func loadImageViews(images: [UIImage]) {
        for (index, image) in images.enumerate() {
            categoryImageViews[index].hidden = false
            categoryImageViews[index].image = image
        }
    }
    
    func updateCategoryIcons(event: Event) {
        
        var imageArray: [UIImage] = []
        for category in event.categories {
            guard let unwrappedCategory = Categories(rawValue: category), let image = unwrappedCategory.selectedImage else {
                print("error: \(NSLocalizedDescriptionKey)")
                return
            }
            imageArray.append(image)
        }
        
        for (index, image) in imageArray.enumerate() {
            
            categoryImageViews[index].image = image
        }
    }
    
    func updateEventDetail(event: Event) {
        eventImageView.image = event.image
        eventTitleLabel.text = event.title
        eventTimeLabel.text = "\(event.startTime)"
        loadImageViews(event.loadCategoriesForEvent())
        if event.endTime == event.endTime {
            eventTimeLabel.text = "\(event.endTime)" } else {
            eventEndTimeLabel.text = "" }
    }
    
    // MARK: - Action Buttons -
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    
    // MARK: tableView data source functions
    
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
            hostDetailCell?.hostNameLabel.text = event?.host.firstName
            return hostDetailCell ?? UITableViewCell()
            
        case 1:
            let priceDetailCell = tableView.dequeueReusableCellWithIdentifier("priceDetailCell", forIndexPath: indexPath) as? PriceDetailTableViewCell
            priceDetailCell?.priceNumberLabel.text = "\(event?.price)"
            return priceDetailCell ?? UITableViewCell()
            
        case 2:
            let locationDetailCell =  tableView.dequeueReusableCellWithIdentifier("locationDetailCell", forIndexPath: indexPath) as? LocationDetailTableViewCell
            locationDetailCell?.addressLabel.text = event?.location.address
            locationDetailCell?.cityStateLabel.text = "\(event?.location.city), \(event?.location.state)"
            locationDetailCell?.zipcodeLabel.text = event?.location.zipCode
            return locationDetailCell ?? UITableViewCell()
            
        case 3:
            let descriptionDetailCell = tableView.dequeueReusableCellWithIdentifier("descriptionDetailCell", forIndexPath: indexPath) as? DescriptionDetailTableViewCell
            descriptionDetailCell?.descriptionTextView.text = event?.eventDescription
            return descriptionDetailCell ?? UITableViewCell()
            
        case 4:
            let moreInfoDetailCell =  tableView.dequeueReusableCellWithIdentifier("moreInfoDetailCell", forIndexPath: indexPath) as? MoreInfoDetailTableViewCell
            moreInfoDetailCell?.moreInfoTextView.text = event?.eventDescription
            return moreInfoDetailCell ?? UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
}
