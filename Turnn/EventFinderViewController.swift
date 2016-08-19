//
//  EventFinderViewController.swift
//  Turnn
//
//  Created by Tyler on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventFinderViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var mapViewPlaceholderView: UIView!
    var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moreOptionsButton: UIBarButtonItem!
    var moreOptionsOn = false
    var mileRadiusViewsOn = false
    
    var adjustMilesView: LogOutView!
    var logOutView: LogOutView!
    var topMilesButton: EventRadiusButton!
    var midMilesButton: EventRadiusButton!
    var lowMilesButton: EventRadiusButton!
    var lowestMilesButton: EventRadiusButton!
    
    let locationManager = CLLocationManager()
    var search: Location?
    var annotation: [MKPointAnnotation]?
    
    var events: [Event] = []
    var oldEvents: [Event] = []
    var futureEvents: [Event] = []
    
    var matchingLocationKeys: [String] = []
    
    var mapCenter: CLLocationCoordinate2D!
    
    var annotations = [MKAnnotation]()
    var usersCurrentLocation: CLLocation? {
        return locationManager.location
    }
    
    var loadingIndicator: UIActivityIndicatorView!
    var loadingIndicatorView: UIView!
    
    var selectedIndexPath: NSIndexPath?
    
    enum Miles: Int {
        case Fifteen = 15
        case Ten = 10
        case Five = 5
        case One = 1
    }
    
    var isFiltered = false
    
    var filteredEvents: [Event] = [] {
        didSet {
            isFiltered = true
            
            
        }
    }
    
    var selectedRadius: Miles = .Five
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicatorView = UIView(frame: CGRectMake((self.view.frame.width / 2) - 30, (self.view.frame.height / 2) - 90, 60, 60))
        loadingIndicatorView.layer.cornerRadius = 15
        loadingIndicatorView.backgroundColor = UIColor.turnnGray().colorWithAlphaComponent(0.8)
        loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, loadingIndicatorView.frame.width, loadingIndicatorView.frame.height))
        loadingIndicator.activityIndicatorViewStyle = .WhiteLarge
        loadingIndicator.hidesWhenStopped = true
        loadingIndicatorView.addSubview(loadingIndicator)
        self.view.addSubview(loadingIndicatorView)
        loadingIndicator.startAnimating()
        
        createMileViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.moreOptionsOn = false
        
        //let styleURL = NSURL(string: "mapbox://styles/ebresciano/cirl1oo0g000dg4m7ofa9mvqk")
        
        self.view.layoutSubviews()
        self.mapView = MKMapView(frame: CGRectMake(self.mapViewPlaceholderView.frame.origin.x, self.mapViewPlaceholderView.frame.origin.y - self.mapViewPlaceholderView.frame.height, self.mapViewPlaceholderView.frame.width, self.mapViewPlaceholderView.frame.height))
        
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        self.mapView.tintColor = UIColor.turnnBlue()
        self.mapView.showsCompass = false
        self.mapView.rotateEnabled = false
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: {
            
            self.mapView.frame = CGRectMake(self.mapViewPlaceholderView.frame.origin.x, self.mapViewPlaceholderView.frame.origin.y, self.mapViewPlaceholderView.frame.width, self.mapViewPlaceholderView.frame.height)
            }, completion: nil)
        
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        setupTableViewUI()
        
        updateQuery()
        
        //
        //        NEXT TWO FUNCTIONS DELETE OLD EVENTS AND THEIR MATCHING LOCATIONS
        //        BUT LET'S LEAVE IT NOW FOR NOW PER JUSTIN'S DATA CONFLICT ADVICE
        //
        //        for event in oldEvents{
        //            EventController.deleteEvent(event)
        //        }
        //
        //        for locationKey in matchingLocationKeys{
        //            EventController.deleteLocation(locationKey)
        //        }
        
    }
    
    func createMapView() {
        self.view.layoutSubviews()
        self.mapView = MKMapView(frame: CGRectMake(self.mapViewPlaceholderView.frame.origin.x, self.mapViewPlaceholderView.frame.origin.y - self.mapViewPlaceholderView.frame.height, self.mapViewPlaceholderView.frame.width, self.mapViewPlaceholderView.frame.height))
        
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        self.mapView.tintColor = UIColor.turnnBlue()
        self.mapView.showsCompass = false
        self.mapView.rotateEnabled = false
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: {
            
            self.mapView.frame = CGRectMake(self.mapViewPlaceholderView.frame.origin.x, self.mapViewPlaceholderView.frame.origin.y, self.mapViewPlaceholderView.frame.width, self.mapViewPlaceholderView.frame.height)
            }, completion: nil)
    }
    
    func updateQuery(){
        
        GeoFireController.queryEventsForRadius(miles: Double(selectedRadius.rawValue), completion: { (currentEvents, oldEvents, matchingLocationKeys, futureEvents) in
            if let currentEvents = currentEvents, oldEvents = oldEvents, matchingLocationKeys = matchingLocationKeys, futureEvents = futureEvents {
                String.printEvents(currentEvents, oldEvents: oldEvents, futureEvents: futureEvents)
                
                self.mapView.removeAnnotations(self.annotations)
                self.annotations = []
                self.events = currentEvents
                
                self.loadingIndicatorView.hidden = true
                self.loadingIndicator.stopAnimating()
                self.displayEvents()
                self.tableView.reloadData()
                
                self.oldEvents = oldEvents
                self.futureEvents = futureEvents
                //these matching location keys are tracked here
                //for sake of deleting them at the same time
                //as old events. they might more properly be
                //called: "locationKeysForOldEvents"
                self.matchingLocationKeys = matchingLocationKeys
            }
        })
        //  OLD MOCK DATA WIRE-UP
//        self.events = EventController.mockEvents()
//        self.displayEvents()
//        self.tableView.reloadData()
//        self.loadingIndicatorView.hidden = true
//        self.loadingIndicator.stopAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.bringSubviewToFront(topMilesButton)
        self.view.bringSubviewToFront(midMilesButton)
        self.view.bringSubviewToFront(lowMilesButton)
        self.view.bringSubviewToFront(lowestMilesButton)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.mapView.delegate = nil
        self.mapView.removeFromSuperview()
        self.mapView = nil
    }
    
    func displayEvents() {
        if isFiltered {
            for event in filteredEvents {
                let point = MKPointAnnotation()
                if let latitude = event.location.latitude, longitude = event.location.longitude {
                    point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                
                self.mapView.rotateEnabled = false
                self.mapView.showsCompass = false
                point.title = event.title
                point.subtitle = event.location.address
                annotations.append(point)
            }
            self.mapView.addAnnotations(annotations)
            
        } else {
            for event in events {
                let point = MKPointAnnotation()
                if let latitude = event.location.latitude, longitude = event.location.longitude {
                    point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                
                self.mapView.rotateEnabled = false
                self.mapView.showsCompass = false
                point.title = event.title
                point.subtitle = event.location.address
                annotations.append(point)
            }
            self.mapView.addAnnotations(annotations)
        }
    }
    
    //    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    //        // This example is only concerned with point annotations.
    //        guard annotation is MKPointAnnotation else {
    //            return nil
    //        }
    //
    //        //let reuseIdentifier = "\(annotation.coordinate.longitude)"
    //
    //        //var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
    //
    ////        if annotationView == nil {
    ////            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
    ////            annotationView!.frame = CGRectMake(0, 40, 25, 25)
    ////
    ////            // Set the annotation view’s background color to a value determined by its longitude.
    ////            _ = CGFloat(annotation.coordinate.longitude) / 100
    ////            annotationView!.backgroundColor = UIColor(hue: 0.10, saturation: 0.64, brightness: 0.98, alpha: 1.00)
    ////        }
    ////        return annotationView
    //    }
    
    // MGLAnnotationView subclass
    class CustomAnnotationView: MKAnnotationView {
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // Force the annotation view to maintain a constant size when the map is tilted.
            //scalesWithViewingDistance = false
            
            // Use CALayer’s corner radius to turn this view into a circle.
            layer.cornerRadius = frame.width / 2
            layer.borderWidth = 2
            layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    // MARK: - TableView Appearance
    
    //    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    //        cell.separatorInset = UIEdgeInsetsZero
    //        cell.layoutMargins = UIEdgeInsetsZero
    //    }
    
    func setupTableViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.turnnGray()
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
        self.tableView.separatorColor = .whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        setBackgroundAndTableView()
    }
    
    func setBackgroundAndTableView() {
        
        self.tableView.backgroundColor = .clearColor()
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let imageView = UIImageView(image: UIImage(named: "Turnn Background")!)
        imageView.contentMode = .Center
        imageView.addSubview(blurView)
        imageView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        blurView.frame = self.view.bounds
    }
    
    // MARK: - Location Manager Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // let location = locations.last
        mapCenter = CLLocationCoordinate2DMake(usersCurrentLocation?.coordinate.latitude ?? 0.0, usersCurrentLocation?.coordinate.longitude ?? 0.0)
        self.mapView.setCenterCoordinate(mapCenter, animated: true)
        self.locationManager.stopUpdatingLocation()
        let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
        self.mapView.setRegion(region, animated: false)
    }
    
    @IBAction func unwindToEventFinder(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToEventFinder" {
            let categoryVC = segue.sourceViewController as! CategoryCollectionViewController
            let filteredEvents = EventController.filterEventsByCategories(events, categories: categoryVC.categories)
            if filteredEvents != nil {
                self.filteredEvents = filteredEvents!
                updateQuery()
            } else {
                presentAlert()
            }
        }
    }
    
    func mapViewUpdated(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("UPDATED")
    }
    
    func mapView(mapView: MKMapView, annotationCanShowCallout annotation: MKAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    // MARK: - Table view data source -
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if isFiltered {
            return filteredEvents.count
        } else {
            return events.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isFiltered {
            let eventCell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as? EventFinderTableViewCell
            
            let event = filteredEvents[indexPath.section]
            eventCell?.updateWithEvent(event)
            
            return eventCell ?? UITableViewCell()
        } else {
            let eventCell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as? EventFinderTableViewCell
            
            let event = events[indexPath.section]
            eventCell?.updateWithEvent(event)
            
            return eventCell ?? UITableViewCell()
        }
    }
    
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? EFHeaderCellTableViewCell
    //        headerCell?.backgroundColor = UIColor.turnnGray()
    //        headerCell?.headerLabel.text = "Events"
    //        headerCell?.headerLabel.textColor = UIColor.turnnWhite()
    //        headerCell?.layer.borderWidth = 1
    //        headerCell?.layer.borderColor = UIColor.turnnBlue().CGColor
    //        headerCell?.layer.masksToBounds = false
    //        //headerCell?.layer.cornerRadius = 5
    //        headerCell?.clipsToBounds = true
    //        return headerCell
    //    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 0.5))
        view.backgroundColor = UIColor.whiteColor()
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegueWithIdentifier("toDetailSegue", sender: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func moreOptionsButtonTapped(sender: AnyObject) {
        
        moreOptionsOn = !moreOptionsOn
        
        addAccessoryView(moreOptionsOn)
    }
    
    func searchAllButtonTapped() {
        isFiltered = false
        tableView.reloadData()
    }

    func categoriesButtonTapped() {
        self.performSegueWithIdentifier("toCategoriesSegue", sender: nil)
    }
    
    func logoutButtonTapped() {

        print("logged out tapped")
        UserController.logOutUser()
        self.performSegueWithIdentifier("nonUnwindToLogin", sender: self)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "No events found", message: "So Sorry! No events with selected categories could be found", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        
        alertController.addAction(dismissAction)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toCategoriesSegue" {
            let navController = segue.destinationViewController as? UINavigationController
            let categoryVC = navController?.viewControllers.first as? CategoryCollectionViewController
            categoryVC?.mode = .Search
        }
        
        if segue.identifier == "toDetailSegue" {
            if let eventDetailVC = segue.destinationViewController as? EventDetailViewController, let indexPath = self.selectedIndexPath {
                let event = events[indexPath.section]
                eventDetailVC.event = event
            }
        }
    }
}

// MARK: - Radius Views + Accesory View

extension EventFinderViewController {
    
    func createMileViews() {
        topMilesButton = EventRadiusButton(frame: CGRectMake(-5, (self.view.frame.height / 2) + 20, 35, 35))
        topMilesButton.setTitle("15", forState: .Normal)
        topMilesButton.setTitleColor(UIColor.turnnBlue(), forState: .Normal)
        topMilesButton.tag = Miles.Fifteen.rawValue
        topMilesButton.addTarget(self, action: #selector(changeRadius(_:)), forControlEvents: .TouchUpInside)
        
        midMilesButton = EventRadiusButton(frame: CGRectMake(-5, (self.view.frame.height / 2) + 20, 35, 35))
        midMilesButton.setTitle("10", forState: .Normal)
        midMilesButton.setTitleColor(UIColor.turnnBlue(), forState: .Normal)
        midMilesButton.tag = Miles.Ten.rawValue
        midMilesButton.addTarget(self, action: #selector(changeRadius(_:)), forControlEvents: .TouchUpInside)
        
        lowMilesButton = EventRadiusButton(frame: CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 80, 35))
        lowMilesButton.setTitle("5 mi", forState: .Normal)
        lowMilesButton.setTitleColor(UIColor.turnnBlue(), forState: .Normal)
        lowMilesButton.tag = Miles.Five.rawValue
        lowMilesButton.addTarget(self, action: #selector(changeRadius(_:)), forControlEvents: .TouchUpInside)
        
        lowestMilesButton = EventRadiusButton(frame: CGRectMake(-5, (self.view.frame.height / 2) + 20, 35, 35))
        lowestMilesButton.setTitle("1", forState: .Normal)
        lowestMilesButton.setTitleColor(UIColor.turnnBlue(), forState: .Normal)
        lowestMilesButton.tag = Miles.One.rawValue
        lowestMilesButton.addTarget(self, action: #selector(changeRadius(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(topMilesButton)
        self.view.addSubview(midMilesButton)
        self.view.addSubview(lowMilesButton)
        self.view.addSubview(lowestMilesButton)
        
        self.topMilesButton.hidden = true
        self.midMilesButton.hidden = true
        self.lowestMilesButton.hidden = true
    }
    
    func addRadiusViews() {
        
        mileRadiusViewsOn = !mileRadiusViewsOn
        
        self.view.bringSubviewToFront(topMilesButton)
        self.view.bringSubviewToFront(midMilesButton)
        self.view.bringSubviewToFront(lowMilesButton)
        self.view.bringSubviewToFront(lowestMilesButton)
        
        self.topMilesButton.hidden = false
        self.midMilesButton.hidden = false
        self.lowMilesButton.hidden = false
        self.lowestMilesButton.hidden = false
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            self.topMilesButton.alpha = 0.9
            self.midMilesButton.alpha = 0.9
            self.lowMilesButton.alpha = 0.9
            self.lowestMilesButton.alpha = 0.9
            
            self.topMilesButton.setTitle("15", forState: .Normal)
            self.midMilesButton.setTitle("10", forState: .Normal)
            self.lowMilesButton.setTitle("5", forState: .Normal)
            self.lowestMilesButton.setTitle("1", forState: .Normal)
            self.topMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
            self.midMilesButton.frame = CGRectMake(self.view.frame.width - 285, (self.view.frame.height / 2) + 20, 35, 35)
            self.lowMilesButton.frame = CGRectMake(self.view.frame.width - 215, (self.view.frame.height / 2) + 20, 35, 35)
            self.lowestMilesButton.frame = CGRectMake(self.view.frame.width - 145, (self.view.frame.height / 2) + 20, 35, 35)
            
            }, completion: nil)
    }
    
    func addAccessoryView(show: Bool) {
        if show {
            logOutView = LogOutView(frame: CGRectMake(self.mapViewPlaceholderView.frame.width + 5, 78, self.mapViewPlaceholderView.frame.width + 20, 35))
            
            let filterButton = UIButton(frame: CGRectMake(0,0,logOutView.frame.width / 2 - 20, logOutView.frame.height))
            filterButton.setTitle("Filter", forState: .Normal)
            filterButton.setTitleColor(UIColor.turnnBlue(), forState: .Normal)
            filterButton.addTarget(self, action: #selector(categoriesButtonTapped), forControlEvents: .TouchUpInside)
            
            let logoutButton = UIButton(frame: CGRectMake(self.logOutView.frame.width / 2 - 20,0, self.logOutView.frame.width / 2 - 20, logOutView.frame.height))
            logoutButton.setTitle("Log Out", forState: .Normal)
            logoutButton.setTitleColor(UIColor.turnnBlue(), forState: .Normal)
            logoutButton.addTarget(self, action: #selector(logoutButtonTapped), forControlEvents: .TouchUpInside)
            
            self.logOutView.addSubview(filterButton)
            self.logOutView.addSubview(logoutButton)
            self.view.addSubview(logOutView)
            
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                self.logOutView.alpha = 0.9
                
                self.logOutView.frame = CGRect(x: 10, y: 78, width: self.view.frame.width + 20, height: 35)
                }, completion: nil)
            
        } else {
            dismissAccessoryViews()
        }
    }
    
    func changeRadius(sender: UIButton) {
        switch sender.tag {
        case Miles.Fifteen.rawValue:
            if mileRadiusViewsOn {
                self.selectedRadius = Miles.Fifteen
                let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
                self.mapView.setRegion(region, animated: true)
                UIView.animateWithDuration(0.4, animations: {
                    self.topMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 80, 35)
                    self.topMilesButton.setTitle("15 mi", forState: .Normal)
                    self.midMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.lowMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.lowestMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.midMilesButton.alpha = 0.0
                    self.lowMilesButton.alpha = 0.0
                    self.lowestMilesButton.alpha = 0.0
                    
                    }, completion: { _ in
                        self.midMilesButton.hidden = true
                        self.lowMilesButton.hidden = true
                        self.lowestMilesButton.hidden = true
                })
                mileRadiusViewsOn = !mileRadiusViewsOn
                updateQuery()
                print(self.selectedRadius)
            } else {
                addRadiusViews()
            }
            
            break
        case Miles.Ten.rawValue:
            if mileRadiusViewsOn {
                self.selectedRadius = Miles.Ten
                let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
                self.mapView.setRegion(region, animated: true)
                UIView.animateWithDuration(0.4, animations: {
                    self.topMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.midMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 80, 35)
                    self.midMilesButton.setTitle("10 mi", forState: .Normal)
                    self.lowMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.lowestMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.topMilesButton.alpha = 0.0
                    self.lowMilesButton.alpha = 0.0
                    self.lowestMilesButton.alpha = 0.0
                    
                    }, completion: { _ in
                        self.topMilesButton.hidden = true
                        self.lowMilesButton.hidden = true
                        self.lowestMilesButton.hidden = true
                })
                mileRadiusViewsOn = !mileRadiusViewsOn
                updateQuery()
                print(self.selectedRadius)
            } else {
                addRadiusViews()
            }
            
            break
        case Miles.Five.rawValue:
            if mileRadiusViewsOn {
                self.selectedRadius = Miles.Five
                let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
                self.mapView.setRegion(region, animated: true)
                UIView.animateWithDuration(0.4, animations: {
                    self.topMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.midMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.lowMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 80, 35)
                    self.lowMilesButton.setTitle("5 mi", forState: .Normal)
                    self.lowestMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.midMilesButton.alpha = 0.0
                    self.topMilesButton.alpha = 0.0
                    self.lowestMilesButton.alpha = 0.0
                    
                    }, completion: { _ in
                        self.midMilesButton.hidden = true
                        self.topMilesButton.hidden = true
                        self.lowestMilesButton.hidden = true
                })
                mileRadiusViewsOn = !mileRadiusViewsOn
                updateQuery()
                print(self.selectedRadius)
            } else {
                addRadiusViews()
            }
            
            break
        case Miles.One.rawValue:
            if mileRadiusViewsOn {
                self.selectedRadius = Miles.One
                let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
                self.mapView.setRegion(region, animated: true)
                UIView.animateWithDuration(0.4, animations: {
                    self.topMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.midMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.lowMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 35, 35)
                    self.lowestMilesButton.frame = CGRectMake(self.view.frame.width - 355, (self.view.frame.height / 2) + 20, 80, 35)
                    self.lowestMilesButton.setTitle("1 mi", forState: .Normal)
                    self.midMilesButton.alpha = 0.0
                    self.lowMilesButton.alpha = 0.0
                    self.topMilesButton.alpha = 0.0
                    
                    }, completion: { _ in
                        self.midMilesButton.hidden = true
                        self.lowMilesButton.hidden = true
                        self.topMilesButton.hidden = true
                })
                mileRadiusViewsOn = !mileRadiusViewsOn
                updateQuery()
                print(self.selectedRadius)
            } else {
                addRadiusViews()
            }
            
            break
        default:
            break
        }
    }
    
    func dismissAccessoryViews() {
        UIView.animateWithDuration(0.4, animations: {
            self.logOutView.alpha = 0.0
            self.logOutView.frame = CGRect(x: self.mapViewPlaceholderView.frame.width + 5, y: 78, width: self.view.frame.width + 20, height: 35)
            //self.adjustMilesView.alpha = 0.0
            //self.adjustMilesView.frame = CGRect(x: self.mapViewPlaceholderView.frame.width + 5, y: 123, width: self.view.frame.width + 20, height: 35)
            }, completion: { _ in
                self.logOutView.removeFromSuperview()
                //self.adjustMilesView.removeFromSuperview()
        })
    }
}


