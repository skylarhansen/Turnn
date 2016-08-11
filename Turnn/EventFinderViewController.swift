//
//  EventFinderViewController.swift
//  Turnn
//
//  Created by Tyler on 8/2/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class EventFinderViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MGLMapViewDelegate {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var search: Location?
    var annotation: [MGLPointAnnotation]?
    var events: [Event] = [] {
        didSet {
            if mapView != nil {
                updateMap(mapView)
            }
        }
    }
    
    var annotations = [MGLAnnotation]()
    var usersCurrentLocation: CLLocation? {
        return locationManager.location
    }
    
    var loadingIndicator: UIActivityIndicatorView!
    var loadingIndicatorView: UIView!
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutSubviews()
        loadingIndicatorView = UIView(frame: CGRectMake((self.view.frame.width / 2) - 30, (self.view.frame.height / 2) - 90, 60, 60))
        loadingIndicatorView.layer.cornerRadius = 15
        loadingIndicatorView.backgroundColor = UIColor.turnnGray().colorWithAlphaComponent(0.8)
        loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, loadingIndicatorView.frame.width, loadingIndicatorView.frame.height))
        loadingIndicator.activityIndicatorViewStyle = .WhiteLarge
        loadingIndicator.hidesWhenStopped = true
        loadingIndicatorView.addSubview(loadingIndicator)
        self.view.addSubview(loadingIndicatorView)
        loadingIndicator.startAnimating()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        // Do this when not using mock data
        /*
         
         GeoFireController.queryEventsForRadius(miles: 5.0, completion: { (currentEvents, oldEvents) in
         if let currentEvents = currentEvents, oldEvents = oldEvents {
         String.printEvents(currentEvents, oldEvents: oldEvents)
         self.events = currentEvents
         self.tableView.reloadData()
         self.loadingIndicatorView.hidden = true
         self.loadingIndicator.stopAnimating()
         self.displayEvents()
         self.updateMap(self.mapView)
         }
         })
         
         */
        
        // Mock data to use for now
        self.events = EventController.mockEvents()
        self.tableView.reloadData()
        self.loadingIndicatorView.hidden = true
        self.loadingIndicator.stopAnimating()
        self.displayEvents()
        self.updateMap(self.mapView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTableViewUI()
        setBackgroundForTableView()
    }
    
    func updateMap(mapView:MGLMapView){
        if let annotations = mapView.annotations {
            for i in annotations {
                mapView.addAnnotation(i)
                mapView.removeAnnotation(i)
                mapView.showAnnotations( annotations , animated: false)
                mapView.showsUserLocation = true
                mapView.userTrackingMode = MGLUserTrackingMode(rawValue: 2)!
            }
        }
    }
    
    func displayEvents() {
        for event in events {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude)
            point.title = event.title
            point.subtitle = event.location.address
            annotations.append(point)
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRectMake(0, 40, 25, 25)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            _ = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: 0.10, saturation: 0.64, brightness: 0.98, alpha: 1.00)
        }
        return annotationView
        
    }
    
    // MGLAnnotationView subclass
    class CustomAnnotationView: MGLAnnotationView {
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // Force the annotation view to maintain a constant size when the map is tilted.
            scalesWithViewingDistance = false
            
            // Use CALayer’s corner radius to turn this view into a circle.
            layer.cornerRadius = frame.width / 2
            layer.borderWidth = 2
            layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    // MARK: - TableView Appearance
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func setupTableViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.278, green: 0.310, blue: 0.310, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)
        self.tableView.separatorColor = .whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        setBackgroundForTableView()
    }
    
    func setBackgroundForTableView() {
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let imageView = UIImageView(image: UIImage(named: "Turnn Background")!)
        imageView.contentMode = .Center
        imageView.addSubview(blurView)
        self.tableView.backgroundView = imageView
        blurView.frame = self.view.bounds
    }
    
    // MARK: - Location Manager Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // let location = locations.last
        let center = CLLocationCoordinate2DMake(usersCurrentLocation?.coordinate.latitude ?? 0.0, usersCurrentLocation?.coordinate.longitude ?? 0.0)
        mapView.setCenterCoordinate(center, zoomLevel: 12, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func unwindToEventFinder(segue: UIStoryboardSegue) {
        
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    // MARK: - Fetch Events -
    // (no longer needed, the GeofireController.queryEventsForRadius function
    // in the viewWillAppear fetches events within a designated search radius)
    
    //    func fetchEvents() {
    //        EventController.fetchEvents { (events) in
    //            self.events = events
    //            self.tableView.reloadData()
    //        }
    //    }
    
    // MARK: - Table view data source -
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as? EventFinderTableViewCell
        
        let event = events[indexPath.row]
        eventCell?.updateWithEvent(event)
        
        return eventCell ?? UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegueWithIdentifier("toDetailSegue", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "searchCategories" {
            let navController = segue.destinationViewController as? UINavigationController
            let categoryVC = navController?.viewControllers.first as? CategoryCollectionViewController
            categoryVC?.mode = .Search
        }
        
        if segue.identifier == "toDetailSegue" {
            if let eventDetailVC = segue.destinationViewController as? EventDetailViewController, let indexPath = self.selectedIndexPath {
                let event = events[indexPath.row]
                eventDetailVC.event = event
            }
        }
    }
}