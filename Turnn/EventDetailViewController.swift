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
    
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var backgroundImageView: UIImageView!
    @IBOutlet weak fileprivate var eventTitleLabel: UILabel!
    @IBOutlet weak fileprivate var eventTimeLabel: UILabel!
    @IBOutlet weak fileprivate var eventDateLabel: UILabel!
    @IBOutlet fileprivate var categoryImageViews: [UIImageView]!
    @IBOutlet weak fileprivate var categoryImageHolderView: UIView!
    @IBOutlet weak fileprivate var backButton: UIButton!
    @IBOutlet weak fileprivate var mapButton: UIButton!
    @IBOutlet weak fileprivate var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        visualEffectView.frame = self.view.bounds
        
        backgroundImageView.addSubview(visualEffectView)
        
        mapButton.layer.borderWidth = 3
        mapButton.layer.borderColor = UIColor.black.cgColor
        mapButton.layer.masksToBounds = false
        mapButton.layer.cornerRadius = mapButton.frame.width/2
        mapButton.clipsToBounds = true
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        categoryImageHolderView.backgroundColor = UIColor.turnnGray()
        
        for imageView in categoryImageViews {
            imageView.isHidden = true
        }
        
        if let event = event {
            updateEventDetail(event)
        }
        
        let string = NSAttributedString(string: "Back to Events", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)])
        backButton.setAttributedTitle(string, for: UIControlState())
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
    }
    
    func loadImageViews(_ images: [UIImage]) {
        for (index, image) in images.enumerated() {
            categoryImageViews[index].isHidden = false
            categoryImageViews[index].image = image
        }
    }
    
    func updateEventDetail(_ event: Event) {
        
        eventTitleLabel.text = event.title
        eventTimeLabel.text = "\(event.startTime.dateFormat()) - \(event.endTime.dateFormat())"
        loadImageViews(event.loadCategoriesForEvent())
        
        if event.startTime.dateOnly() == event.endTime.dateOnly() {
            eventDateLabel.text = event.startTime.dateOnly()
        } else {
            eventDateLabel.text = "\(event.startTime.dateOnly()) - \(event.endTime.dateOnly())"
        }
        
        ImageController.imageForUrl(event.imageURL!) { (image) in
            self.mapButton.setBackgroundImage(image, for: UIControlState())
        }
    }
    
    // MARK: - Action Buttons -
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mapButtonTapped(_ sender: AnyObject) {
        guard let latitude = self.event?.location.latitude, let longitude = self.event?.location.longitude else {
            return
        }
        let url = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=w")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func locationButtonTapped(_ sender: AnyObject) {
        presentAlertController()
    }
    // MARK: - Alert Controller
    
    func presentAlertController() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let mapsAction = UIAlertAction(title: "Maps", style: .default) { (_) in
            guard let latitude = self.event?.location.latitude, let longitude = self.event?.location.latitude else {
                return
            }
            
            let url = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=w")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(mapsAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - tableView data source functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            return UITableViewAutomaticDimension
        case 3:
            if event != nil && event?.eventDescription == "" {
                return 0
            } else {
                return UITableViewAutomaticDimension
            }
        case 4:
            if event != nil && event?.moreInfo == "" {
                return 0
            } else {
            return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            let hostDetailCell = tableView.dequeueReusableCell(withIdentifier: "hostDetailCell", for: indexPath) as? HostDetailTableViewCell
            hostDetailCell?.hostNameLabel.text = (event?.host.firstName)! + " " + (event?.host.lastName)!
            return hostDetailCell ?? UITableViewCell()
            
        case 1:
            let locationDetailCell =  tableView.dequeueReusableCell(withIdentifier: "locationDetailCell", for: indexPath) as? LocationDetailTableViewCell
            locationDetailCell?.updateLocationWithEvent(event!)
            //            locationDetailCell?.streetNumberLabel.text = event?.location.address
            //            locationDetailCell?.cityStateLabel.text = "\(event!.location.city), \(event!.location.state)"
            //            locationDetailCell?.zipcodeLabel.text = event?.location.zipCode
            return locationDetailCell ?? UITableViewCell()
            
        case 2:
            let priceDetailCell = tableView.dequeueReusableCell(withIdentifier: "priceDetailCell", for: indexPath) as? PriceDetailTableViewCell
            if let price = event?.price {
                priceDetailCell?.priceNumberLabel.text = "\(price)"
            } else {
                priceDetailCell?.priceNumberLabel.text = "Free"
            }
            return priceDetailCell ?? UITableViewCell()
            
        case 3:
            if event != nil && event?.eventDescription == "" {
            let blankCell = UITableViewCell()
            blankCell.isHidden = true
            return blankCell
            } else {
            let descriptionDetailCell = tableView.dequeueReusableCell(withIdentifier: "descriptionDetailCell", for: indexPath) as? DescriptionDetailTableViewCell
            descriptionDetailCell?.detailedDescriptionLabel.text = event?.eventDescription
                return descriptionDetailCell ?? UITableViewCell()
            }
            
        case 4:
            if event != nil && event?.moreInfo == "" {
                let blankCell = UITableViewCell()
                blankCell.isHidden = true
                return blankCell
            } else {
            let moreInfoDetailCell =  tableView.dequeueReusableCell(withIdentifier: "moreInfoDetailCell", for: indexPath) as? MoreInfoDetailTableViewCell
            moreInfoDetailCell?.moreInfoDetailLabel.text = event?.moreInfo
                return moreInfoDetailCell ?? UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - REPORTING, outlet is currently disconnected, ALSO
    // DO NOT USE WITH MOCK DATA, our mock data events don't have identifiers,
    // it will cause a crash. can leave optional but then it will
    // print odd text in email report when we use the REAL DATA
    
    
    @IBAction func actionButtonTapped(_ sender: AnyObject) {
        reportEvent()
    }
    
    
    func showSendMailErrorAlert(){
        let sendMailErrorAlert =
            UIAlertController(title: "Couldn't Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel){ (action) in print(action)}
        sendMailErrorAlert.addAction(dismissAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func reportEvent(){
        if event != nil {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Report event as inappropriate", style: .destructive) { action in
                
                if MFMailComposeViewController.canSendMail() {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    composeVC.setToRecipients(["report@honestbadger.com"])
                    composeVC.setSubject("Inappropriate Event Report")
                    composeVC.setMessageBody("Event to report:\n'\(self.event!.title)'\n\n Thank you for your report! Do you have any comments to add?: \n\n\n\n\n\n\n \n*******************\nDeveloper Data:\neid:\(self.event!.identifier!) \nuid:\(self.event!.host.identifier!)\nst:\(self.event!.startTime.timeIntervalSince1970)\n*******************", isHTML: false)
                    
                    self.present(composeVC, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
                
                })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                })
            present(alert, animated: true, completion: nil)
        }
    }
}
