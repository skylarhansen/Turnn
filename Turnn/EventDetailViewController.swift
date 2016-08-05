//
//  EventDetailViewController.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
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
        
        let eventLocation = CLLocation(latitude: 51.5032510, longitude: -0.1278950)
        
        centerMapOnLocation(eventLocation)
    }
   
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var eventEndTimeLabel: UILabel!
   
    @IBOutlet var categoryImageViews: [UIImageView]!
    
    func updateCategoryIcons(event: Event) {
        
        var imageArray: [UIImage] = []
        for category in event.categories {
            guard let unwrappedCategory = Categories(rawValue: category.rawValue), let image = unwrappedCategory.image else {
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
        if event.endTime == event.endTime {
            eventTimeLabel.text = "\(event.endTime)" } else {
               eventEndTimeLabel.text = "" }
        }
    
    // MARK: Map functions
    
//    func updateMapWithEventLocation(location: Location) {
//        mapView.centerCoordinate =
//
//    }
    
    let regionRadius: CLLocationDistance = 20
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    // MARK: tableView data source functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            let HostDetailCell = tableView.dequeueReusableCellWithIdentifier("hostDetailCell", forIndexPath: indexPath)
            return HostDetailCell ?? UITableViewCell()
            
        case 1:
            let PriceDetailCell = tableView.dequeueReusableCellWithIdentifier("priceDetailCell", forIndexPath: indexPath)
            return PriceDetailCell ?? UITableViewCell()
            
        case 2:
            let LocationDetailCell =  tableView.dequeueReusableCellWithIdentifier("locationDetailCell", forIndexPath: indexPath)
            return LocationDetailCell ?? UITableViewCell()
            
        case 3:
            let DescriptionDetailCell = tableView.dequeueReusableCellWithIdentifier("descriptionDetailCell", forIndexPath: indexPath)
            return DescriptionDetailCell ?? UITableViewCell()
            
        case 4:
            let MoreInfoDetailCell =  tableView.dequeueReusableCellWithIdentifier("moreInfoDetailCell", forIndexPath: indexPath)
            return MoreInfoDetailCell ?? UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
    
}
