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
    
    @IBOutlet weak fileprivate var mapViewPlaceholderView: UIView!
    var mapView: MKMapView!
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var noEventsPlaceholderView: UIView!
    @IBOutlet weak fileprivate var moreOptionsButton: UIBarButtonItem!
    @IBOutlet weak fileprivate var noEventsLabel1: UILabel!
    @IBOutlet weak fileprivate var noEventsLabel2: UILabel!
    @IBOutlet weak fileprivate var noEventsButtonOutlet: UIButton!
    @IBOutlet weak fileprivate var noEventsChangeRadiusButtonOutlet: UIButton!
    @IBOutlet weak fileprivate var noEventsRemoveFiltersButtonOutlet: UIButton!
    
    var moreOptionsOn = false
    var mileRadiusViewsOn = false
    
    var adjustMilesView: LogOutView!
    var logOutView: LogOutView!
    var myEventsView: LogOutView!
    var topMilesButton: EventRadiusButton!
    var midMilesButton: EventRadiusButton!
    var lowMilesButton: EventRadiusButton!
    var lowestMilesButton: EventRadiusButton!
    
    var currentFiltration: [Int] = []
    
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
   
    var selectedIndexPath: IndexPath?
    
    enum Miles: Int {
        case fifteen = 15
        case ten = 10
        case five = 5
        case one = 1
    }
    
    var isFiltered = false
    
    var filteredEvents: [Event] = [] {
        didSet {
            isFiltered = true
        }
    }
    
    var selectedRadius: Miles = .fifteen
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicatorView = UIView(frame: CGRect(x: (self.view.frame.width / 2) - 30, y: (self.view.frame.height / 2) - 90, width: 60, height: 60))
        loadingIndicatorView.layer.cornerRadius = 15
        loadingIndicatorView.backgroundColor = UIColor.turnnGray().withAlphaComponent(0.8)
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: loadingIndicatorView.frame.width, height: loadingIndicatorView.frame.height))
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.hidesWhenStopped = true
        loadingIndicatorView.addSubview(loadingIndicator)
        self.view.addSubview(loadingIndicatorView)
        loadingIndicator.startAnimating()
        createMileViews()
        
        noEventsLabel1.textColor = UIColor.turnnWhite().withAlphaComponent(0.9)
        noEventsLabel2.textColor = UIColor.turnnWhite().withAlphaComponent(0.9)
        
        noEventsButtonOutlet.backgroundColor = UIColor.turnnBlue().withAlphaComponent(0.8)
        noEventsChangeRadiusButtonOutlet.backgroundColor = UIColor.turnnBlue().withAlphaComponent(0.8)
        noEventsRemoveFiltersButtonOutlet.backgroundColor = UIColor.turnnBlue().withAlphaComponent(0.8)
        
        noEventsButtonOutlet.titleLabel?.textColor = UIColor.turnnGray().withAlphaComponent(0.8)
        noEventsChangeRadiusButtonOutlet.titleLabel?.textColor = UIColor.turnnGray().withAlphaComponent(0.8)
        noEventsRemoveFiltersButtonOutlet.titleLabel?.textColor = UIColor.turnnGray().withAlphaComponent(0.8)
        
        noEventsButtonOutlet.titleLabel?.textAlignment = NSTextAlignment.center
        noEventsChangeRadiusButtonOutlet.titleLabel?.textAlignment = NSTextAlignment.center
        noEventsRemoveFiltersButtonOutlet.titleLabel?.textAlignment = NSTextAlignment.center
        
        noEventsButtonOutlet.layer.cornerRadius = (noEventsButtonOutlet.frame.width / 2)
        noEventsButtonOutlet.clipsToBounds = true
        
        noEventsChangeRadiusButtonOutlet.layer.cornerRadius =
            (noEventsChangeRadiusButtonOutlet.frame.width / 2)
        noEventsChangeRadiusButtonOutlet.clipsToBounds = true
        
        noEventsRemoveFiltersButtonOutlet.layer.cornerRadius = (noEventsRemoveFiltersButtonOutlet.frame.width / 2)
        noEventsRemoveFiltersButtonOutlet.clipsToBounds = true
        
        noEventsPlaceholderView.isHidden = true
        revealOrHideNoResultsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moreOptionsOn = false
        
        //let styleURL = NSURL(string: "mapbox://styles/ebresciano/cirl1oo0g000dg4m7ofa9mvqk")
        
        self.view.layoutSubviews()
        self.mapView = MKMapView(frame: CGRect(x: self.mapViewPlaceholderView.frame.origin.x, y: self.mapViewPlaceholderView.frame.origin.y - self.mapViewPlaceholderView.frame.height, width: self.mapViewPlaceholderView.frame.width, height: self.mapViewPlaceholderView.frame.height))
        
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        self.mapView.tintColor = UIColor.turnnBlue()
        self.mapView.showsCompass = false
        self.mapView.isRotateEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: {
            
            self.mapView.frame = CGRect(x: self.mapViewPlaceholderView.frame.origin.x, y: self.mapViewPlaceholderView.frame.origin.y, width: self.mapViewPlaceholderView.frame.width, height: self.mapViewPlaceholderView.frame.height)
            }, completion: nil)
        
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        setupTableViewUI()
    }
    
    func createMapView() {
        self.view.layoutSubviews()
        self.mapView = MKMapView(frame: CGRect(x: self.mapViewPlaceholderView.frame.origin.x, y: self.mapViewPlaceholderView.frame.origin.y - self.mapViewPlaceholderView.frame.height, width: self.mapViewPlaceholderView.frame.width, height: self.mapViewPlaceholderView.frame.height))
        
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        self.mapView.tintColor = UIColor.turnnBlue()
        self.mapView.showsCompass = false
        self.mapView.isRotateEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: {
            self.mapView.frame = CGRect(x: self.mapViewPlaceholderView.frame.origin.x, y: self.mapViewPlaceholderView.frame.origin.y, width: self.mapViewPlaceholderView.frame.width, height: self.mapViewPlaceholderView.frame.height)
            }, completion: nil)
        }
    
    func updateQuery(){
        if isFiltered == false {
            GeoFireController.queryEventsForRadius(miles: Double(selectedRadius.rawValue), completion: { (currentEvents, oldEvents, matchingLocationKeys, futureEvents) in
                if let currentEvents = currentEvents, let oldEvents = oldEvents, let matchingLocationKeys = matchingLocationKeys, let futureEvents = futureEvents {
                    String.printEvents(currentEvents, oldEvents: oldEvents, futureEvents: futureEvents)
                    self.mapView.removeAnnotations(self.annotations)
                    self.annotations = []
                
                    self.events = currentEvents
                    //can't do the line below or it'll trigger the didSet for isFiltered
                    //self.filteredEvents = EventController.filterEventsByCategories(currentEvents, categories: self.currentFiltration)!
                
                    self.loadingIndicatorView.isHidden = true
                    self.loadingIndicator.stopAnimating()
                    self.displayEvents()
    
                    self.oldEvents = oldEvents
                    self.futureEvents = futureEvents
                    //these matching location keys are tracked here
                    //for sake of deleting them at the same time
                    //as old events. they might more properly be
                    //called: "locationKeysForOldEvents"
                    self.matchingLocationKeys = matchingLocationKeys
                    self.tableView.reloadData()
                    self.revealOrHideNoResultsView()
            }
        })
    }
        if isFiltered == true {
            GeoFireController.queryEventsForRadius(miles: Double(selectedRadius.rawValue), completion: { (currentEvents, oldEvents, matchingLocationKeys, futureEvents) in
                if let currentEvents = currentEvents, let oldEvents = oldEvents, let matchingLocationKeys = matchingLocationKeys, let futureEvents = futureEvents {
                    String.printEvents(currentEvents, oldEvents: oldEvents, futureEvents: futureEvents)
                    self.mapView.removeAnnotations(self.annotations)
                    self.annotations = []
                    
                    self.events = currentEvents
                    self.filteredEvents = EventController.filterEventsByCategories(currentEvents, categories: self.currentFiltration)!
                    
                    self.loadingIndicatorView.isHidden = true
                    self.loadingIndicator.stopAnimating()
                    self.displayEvents()
                    
                    self.oldEvents = oldEvents
                    self.futureEvents = futureEvents
                    //these matching location keys are tracked here
                    //for sake of deleting them at the same time
                    //as old events. they might more properly be
                    //called: "locationKeysForOldEvents"
                    self.matchingLocationKeys = matchingLocationKeys
                    self.tableView.reloadData()
                    self.revealOrHideNoResultsView()
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.bringSubview(toFront: topMilesButton)
        self.view.bringSubview(toFront: midMilesButton)
        self.view.bringSubview(toFront: lowMilesButton)
        self.view.bringSubview(toFront: lowestMilesButton)
        updateQuery()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mapView.delegate = nil
        self.mapView.removeFromSuperview()
        self.mapView = nil
    }
    
    func displayEvents() {
        if isFiltered {
            for event in self.filteredEvents {
                let point = MKPointAnnotation()
                if let latitude = event.location.latitude, let longitude = event.location.longitude {
                    point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                self.mapView.isRotateEnabled = false
                self.mapView.showsCompass = false
                point.title = event.title
                point.subtitle = event.location.address
                annotations.append(point)
            }
            self.mapView.addAnnotations(annotations)
        } else {
            for event in self.events {
                let point = MKPointAnnotation()
                if let latitude = event.location.latitude, let longitude = event.location.longitude {
                    point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                self.mapView.isRotateEnabled = false
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
            // scalesWithViewingDistance = false
            // Use CALayer’s corner radius to turn this view into a circle.
            layer.cornerRadius = frame.width / 2
            layer.borderWidth = 2
            layer.borderColor = UIColor.white.cgColor
        }
    }
    
    // MARK: - TableView Appearance
    
    func setupTableViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.turnnGray()
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
        self.tableView.separatorColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        setBackgroundAndTableView()
    }
    
    func setBackgroundAndTableView() {
        self.tableView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let imageView = UIImageView(image: UIImage(named: "Turnn Background")!)
        imageView.contentMode = .center
        imageView.addSubview(blurView)
        imageView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        blurView.frame = self.view.bounds
    }
    
    // MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // let location = locations.last
        mapCenter = CLLocationCoordinate2DMake(usersCurrentLocation?.coordinate.latitude ?? 0.0, usersCurrentLocation?.coordinate.longitude ?? 0.0)
        self.mapView.setCenter(mapCenter, animated: true)
        self.locationManager.stopUpdatingLocation()
        let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
        self.mapView.setRegion(region, animated: false)
    }
    
    @IBAction func unwindToEventFinder(_ segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToEventFinder" {
            let categoryVC = segue.source as! CategoryCollectionViewController
            let filteredEvents = EventController.filterEventsByCategories(events, categories: categoryVC.categories)
            currentFiltration = categoryVC.categories
            if filteredEvents != nil {
                self.filteredEvents = filteredEvents!
            } else {
                revealOrHideNoResultsView()
            }
        }
    }
    
    func mapViewUpdated(_ mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("UPDATED")
    }
    
    func mapView(_ mapView: MKMapView, annotationCanShowCallout annotation: MKAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    // MARK: - No Events View Non-Segue Actions -
    
    @IBAction func noEventsChangeRadiusButtonTapped(_ sender: AnyObject) {
        if mileRadiusViewsOn {
        UIView.animate(withDuration: 0.4, animations: {
            self.topMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
            self.midMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
            self.lowMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 80, height: 35)
            self.lowMilesButton.setTitle("\(self.selectedRadius.rawValue) mi", for: UIControlState())
            self.lowestMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
            self.midMilesButton.alpha = 0.0
            self.topMilesButton.alpha = 0.0
            self.lowestMilesButton.alpha = 0.0
            
            }, completion: { _ in
                self.midMilesButton.isHidden = true
                self.topMilesButton.isHidden = true
                self.lowestMilesButton.isHidden = true
        })
        mileRadiusViewsOn = !mileRadiusViewsOn
        } else {
        addRadiusViews()
        }
    }
    
    @IBAction func noEventsRemoveFiltersButtonTapped(_ sender: AnyObject) {
        moreOptionsOn = !moreOptionsOn
        addAccessoryView(moreOptionsOn)
    }
    
    // MARK: - Table view data source -

    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltered == true {
            return filteredEvents.count
        } else {
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    var noResultsSubView: UIView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFiltered {
            
            let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventFinderTableViewCell
            
            let event = self.filteredEvents[indexPath.section]
            eventCell?.updateWithEvent(event)
            
            return eventCell ?? UITableViewCell()
            
        } else {
            let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventFinderTableViewCell
            
            let event = self.events[indexPath.section]
            eventCell?.updateWithEvent(event)
            
            return eventCell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.5))
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "toDetailSegue", sender: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func moreOptionsButtonTapped(_ sender: AnyObject) {
        moreOptionsOn = !moreOptionsOn
        addAccessoryView(moreOptionsOn)
    }
    
    func categoriesButtonTapped() {
        self.performSegue(withIdentifier: "toCategoriesSegue", sender: nil)
    }
    
    func showAllEvents() {
        self.isFiltered = false
        dismissAccessoryViews()
        updateQuery()
    }
    
    func myEventsButtonTapped() {
        self.performSegue(withIdentifier: "ToMyEventsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCategoriesSegue" {
            let navController = segue.destination as? UINavigationController
            let categoryVC = navController?.viewControllers.first as? CategoryCollectionViewController
            categoryVC?.mode = .Search
        }
        
        if segue.identifier == "toDetailSegue" {
            if isFiltered == true {
                if let eventDetailVC = segue.destination as? EventDetailViewController, let indexPath = self.selectedIndexPath {
                    let event = filteredEvents[indexPath.section]
                    eventDetailVC.event = event
                }
            }
            if isFiltered == false {
                if let eventDetailVC = segue.destination as? EventDetailViewController, let indexPath = self.selectedIndexPath {
                    let event = events[indexPath.section]
                    eventDetailVC.event = event
                }
            }
        }
    }
    
    func revealOrHideNoResultsView(){
        
        if isFiltered == true {
            if filteredEvents.count == 0 {
                noEventsPlaceholderView.isHidden = false
                self.tableView.isHidden = true
            }
            if filteredEvents.count > 0 {
                noEventsPlaceholderView.isHidden = true
                self.tableView.isHidden = false
            } else {return}
        }
        
        if isFiltered == false {
            if events.count == 0 {
                noEventsPlaceholderView.isHidden = false
                self.tableView.isHidden = true
            }
            if events.count > 0  {
                noEventsPlaceholderView.isHidden = true
                self.tableView.isHidden = false
            } else {return}
        }
        else {return}
    }
}

// MARK: - Radius Views + Accesory View

extension EventFinderViewController {
    
    func createMileViews() {
        
        topMilesButton = EventRadiusButton(frame: CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 80, height: 35))
        topMilesButton.setTitle("15 mi", for: UIControlState())
        topMilesButton.setTitleColor(UIColor.turnnBlue(), for: UIControlState())
        topMilesButton.tag = Miles.fifteen.rawValue
        topMilesButton.addTarget(self, action: #selector(changeRadius(_:)), for: .touchUpInside)
        
        midMilesButton = EventRadiusButton(frame: CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35))
        midMilesButton.setTitle("10", for: UIControlState())
        midMilesButton.setTitleColor(UIColor.turnnBlue(), for: UIControlState())
        midMilesButton.tag = Miles.ten.rawValue
        midMilesButton.addTarget(self, action: #selector(changeRadius(_:)), for: .touchUpInside)
        
        lowMilesButton = EventRadiusButton(frame: CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35))
        lowMilesButton.setTitle("5", for: UIControlState())
        lowMilesButton.setTitleColor(UIColor.turnnBlue(), for: UIControlState())
        lowMilesButton.tag = Miles.five.rawValue
        lowMilesButton.addTarget(self, action: #selector(changeRadius(_:)), for: .touchUpInside)
        
        lowestMilesButton = EventRadiusButton(frame: CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35))
        lowestMilesButton.setTitle("1", for: UIControlState())
        lowestMilesButton.setTitleColor(UIColor.turnnBlue(), for: UIControlState())
        lowestMilesButton.tag = Miles.one.rawValue
        lowestMilesButton.addTarget(self, action: #selector(changeRadius(_:)), for: .touchUpInside)
        
        self.view.addSubview(topMilesButton)
        self.view.addSubview(midMilesButton)
        self.view.addSubview(lowMilesButton)
        self.view.addSubview(lowestMilesButton)
        
        self.lowMilesButton.isHidden = true
        self.midMilesButton.isHidden = true
        self.lowestMilesButton.isHidden = true
    }
    
    func addRadiusViews() {
        
        mileRadiusViewsOn = !mileRadiusViewsOn
        
        self.view.bringSubview(toFront: topMilesButton)
        self.view.bringSubview(toFront: midMilesButton)
        self.view.bringSubview(toFront: lowMilesButton)
        self.view.bringSubview(toFront: lowestMilesButton)
        
        self.topMilesButton.isHidden = false
        self.midMilesButton.isHidden = false
        self.lowMilesButton.isHidden = false
        self.lowestMilesButton.isHidden = false
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            self.topMilesButton.alpha = 0.9
            self.midMilesButton.alpha = 0.9
            self.lowMilesButton.alpha = 0.9
            self.lowestMilesButton.alpha = 0.9
            
            self.topMilesButton.setTitle("15", for: UIControlState())
            self.midMilesButton.setTitle("10", for: UIControlState())
            self.lowMilesButton.setTitle("5", for: UIControlState())
            self.lowestMilesButton.setTitle("1", for: UIControlState())
            self.topMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
            self.midMilesButton.frame = CGRect(x: self.view.frame.width - 255, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
            self.lowMilesButton.frame = CGRect(x: self.view.frame.width - 185, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
            self.lowestMilesButton.frame = CGRect(x: self.view.frame.width - 115, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
            
            }, completion: nil)
    }
    
    func addAccessoryView(_ show: Bool) {
        if show {
            logOutView = LogOutView(frame: CGRect(x: self.mapViewPlaceholderView.frame.width + 5, y: 78, width: self.mapViewPlaceholderView.frame.width + 20, height: 35))
            myEventsView = LogOutView(frame: CGRect(x: self.mapViewPlaceholderView.frame.width + 5, y: 123, width: self.view.frame.width / 2, height: 35))
            
            let filterButton = UIButton(frame: CGRect(x: 0,y: 0,width: logOutView.frame.width / 2 - 20, height: logOutView.frame.height))
            filterButton.setTitle("Filter", for: UIControlState())
            filterButton.setTitleColor(UIColor.turnnBlue(), for: UIControlState())
            filterButton.addTarget(self, action: #selector(categoriesButtonTapped), for: .touchUpInside)
            
            let showAllButton = UIButton(frame: CGRect(x: self.logOutView.frame.width / 2 - 20,y: 0, width: self.logOutView.frame.width / 2 - 20, height: logOutView.frame.height))
            showAllButton.setTitle("Remove Filters", for: UIControlState())
            showAllButton.setTitleColor(UIColor.turnnBlue(), for: UIControlState())
            showAllButton.addTarget(self, action: #selector(showAllEvents), for: .touchUpInside)
            
            let myEventsButton = UIButton(frame: CGRect(x: 20,y: 0, width: self.myEventsView.frame.width - 10, height: logOutView.frame.height))
            myEventsButton.setTitle("My Events", for: UIControlState())
            myEventsButton.setTitleColor(UIColor.turnnBlue(), for: UIControlState())
            myEventsButton.addTarget(self, action: #selector(myEventsButtonTapped), for: .touchUpInside)
            
            self.logOutView.addSubview(filterButton)
            self.logOutView.addSubview(showAllButton)
            self.myEventsView.addSubview(myEventsButton)
            self.view.addSubview(logOutView)
            self.view.addSubview(myEventsView)
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                self.logOutView.alpha = 0.9
                self.myEventsView.alpha = 0.9

                self.logOutView.frame = CGRect(x: 10, y: 78, width: self.view.frame.width + 20, height: 35)
                self.myEventsView.frame = CGRect(x: (self.view.frame.width / 2) - 10, y: 123, width: (self.view.frame.width / 2) + 40, height: 35)
                }, completion: nil)
            
        } else {
            dismissAccessoryViews()
        }
    }
    
    func changeRadius(_ sender: UIButton) {
        switch sender.tag {
        case Miles.fifteen.rawValue:
            if mileRadiusViewsOn {
                self.selectedRadius = Miles.fifteen
                let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
                self.mapView.setRegion(region, animated: true)
                UIView.animate(withDuration: 0.4, animations: {
                    self.topMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 80, height: 35)
                    self.topMilesButton.setTitle("15 mi", for: UIControlState())
                    self.midMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.lowMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.lowestMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.midMilesButton.alpha = 0.0
                    self.lowMilesButton.alpha = 0.0
                    self.lowestMilesButton.alpha = 0.0
                    
                    }, completion: { _ in
                        self.midMilesButton.isHidden = true
                        self.lowMilesButton.isHidden = true
                        self.lowestMilesButton.isHidden = true
                })
                mileRadiusViewsOn = !mileRadiusViewsOn
                updateQuery()
                print(self.selectedRadius)
            } else {
                addRadiusViews()
            }
            
            break
        case Miles.ten.rawValue:
            if mileRadiusViewsOn {
                self.selectedRadius = Miles.ten
                let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
                self.mapView.setRegion(region, animated: true)
                UIView.animate(withDuration: 0.4, animations: {
                    self.topMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.midMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 80, height: 35)
                    self.midMilesButton.setTitle("10 mi", for: UIControlState())
                    self.lowMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.lowestMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.topMilesButton.alpha = 0.0
                    self.lowMilesButton.alpha = 0.0
                    self.lowestMilesButton.alpha = 0.0
                    
                    }, completion: { _ in
                        self.topMilesButton.isHidden = true
                        self.lowMilesButton.isHidden = true
                        self.lowestMilesButton.isHidden = true
                })
                mileRadiusViewsOn = !mileRadiusViewsOn
                updateQuery()
                print(self.selectedRadius)
            } else {
                addRadiusViews()
            }
            
            break
        case Miles.five.rawValue:
            if mileRadiusViewsOn {
                self.selectedRadius = Miles.five
                let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
                self.mapView.setRegion(region, animated: true)
                UIView.animate(withDuration: 0.4, animations: {
                    self.topMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.midMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.lowMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 80, height: 35)
                    self.lowMilesButton.setTitle("5 mi", for: UIControlState())
                    self.lowestMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) + 20, width: 35, height: 35)
                    self.midMilesButton.alpha = 0.0
                    self.topMilesButton.alpha = 0.0
                    self.lowestMilesButton.alpha = 0.0
                    
                    }, completion: { _ in
                        self.midMilesButton.isHidden = true
                        self.topMilesButton.isHidden = true
                        self.lowestMilesButton.isHidden = true
                })
                mileRadiusViewsOn = !mileRadiusViewsOn
                updateQuery()
                print(self.selectedRadius)
            } else {
                addRadiusViews()
            }
            
            break
        case Miles.one.rawValue:
            if mileRadiusViewsOn {
                self.selectedRadius = Miles.one
                let region = MKCoordinateRegionMakeWithDistance(mapCenter, Double(selectedRadius.rawValue).makeMeters(), Double(selectedRadius.rawValue).makeMeters())
                self.mapView.setRegion(region, animated: true)
                UIView.animate(withDuration: 0.4, animations: {
                    self.topMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.midMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.lowMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 35, height: 35)
                    self.lowestMilesButton.frame = CGRect(x: self.view.frame.width - 325, y: (self.view.frame.height / 2) - 15, width: 80, height: 35)
                    self.lowestMilesButton.setTitle("1 mi", for: UIControlState())
                    self.midMilesButton.alpha = 0.0
                    self.lowMilesButton.alpha = 0.0
                    self.topMilesButton.alpha = 0.0
                    
                    }, completion: { _ in
                        self.midMilesButton.isHidden = true
                        self.lowMilesButton.isHidden = true
                        self.topMilesButton.isHidden = true
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
        UIView.animate(withDuration: 0.4, animations: {
            self.logOutView.alpha = 0.0
            self.myEventsView.alpha = 0.0
            self.moreOptionsOn = false
            self.logOutView.frame = CGRect(x: self.mapViewPlaceholderView.frame.width + 5, y: 78, width: self.view.frame.width + 20, height: 35)
            self.myEventsView.frame = CGRect(x: self.mapViewPlaceholderView.frame.width + 5, y: 123, width: self.view.frame.width / 2, height: 35)
            }, completion: { _ in
                self.logOutView.removeFromSuperview()
                self.myEventsView.removeFromSuperview()
        })
    }
}
