//
//  EventDetailViewController.swift
//  Turnn
//
//  Created by Eva Marie Bresciano on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {
    
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
    }
   
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet var categoryImageViews: [UIImageView]!
    
    func updateCategoryIcons(event: Event) {
        
        var imageArray: [UIImage] = []
        for category in event.categories {
            guard let unwrappedCategory = Categories(rawValue: category.rawValue), let image = unwrappedCategory.image else {
                print("")
                return
            }
            imageArray.append(image)
        }
        
        for (index, image) in imageArray.enumerate() {
            
            categoryImageViews[index].image = image
        }

//        let category = event.categories[0]
        
    }
    
    func updateBackgroundImage(event: Event) {
        eventImageView.image = event.image
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
       /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
