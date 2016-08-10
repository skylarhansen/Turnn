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
    var events: [Event] = []
    var annotations = [MGLAnnotation]()
    var usersCurrentLocation: CLLocation? {
        return locationManager.location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViewUI()
        setBackgroundForTableView()
        //fetchEvents()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        // MARK: - MOCK DATA
        
        self.events = EventController.mockEvents()
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 40.761823, longitude: -111.890594)
        point.title = "Dev Mountain"
        point.subtitle = "341 Main St Salt Lake City, U.S.A"
        
        mapView.addAnnotation(point)
    }
    
    func updateMap(mapView:MGLMapView){
        if let annotations = mapView.annotations {
            for i in annotations {
                mapView.addAnnotation(i)
                mapView.removeAnnotation(i)
                mapView.showAnnotations(i as! [MGLAnnotation], animated: false)
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
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // MARK: - TableView Appearance
        return MGLAnnotationView()
    }
    
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
        let location = locations.last
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
    
    func fetchEvents() {
        EventController.fetchEvents { (events) in
            self.events = events
            self.tableView.reloadData()
        }
    }
    
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "searchCategories" {
            let navController = segue.destinationViewController as? UINavigationController
            let categoryVC = navController?.viewControllers.first as? CategoryCollectionViewController
            categoryVC?.mode = .Search
        }
    }
    
}



