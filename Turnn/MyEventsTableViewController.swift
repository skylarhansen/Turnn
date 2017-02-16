//
//  MyEventsTableViewController.swift
//  Turnn
//
//  Created by Justin Smith on 8/18/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class MyEventsTableViewController: UITableViewController {
    
    var events: [Event] = []
    
    let legalButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        EventController.fetchEventsForUserID(UserController.shared.currentUserId) { (events) in
            if let events = events {
                self.events = events
                self.tableView.reloadData()
            } else {
                print("EVENTS IS NIL")
            }
        }
        setupTableViewUI()
        createFloatyLegalAndPrivacyButton()
    }
    
    @IBAction func logOutButtonTapped() {
        print("logged out tapped")
        UserController.logOutUser()
        self.performSegue(withIdentifier: "logOutSegue", sender: self)
    }
    
    @IBAction func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTableViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.turnnGray()
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
        self.tableView.separatorColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        setBackgroundForTableView()
    }
    
    func setBackgroundForTableView() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        let imageView = UIImageView(image: UIImage(named: "Turnn Background")!)
        imageView.contentMode = .center
        
        imageView.addSubview(blurView)
        tableView.backgroundView = imageView
        blurView.frame = imageView.frame
        createFloatyLegalAndPrivacyButton()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame = self.legalButton.frame
        frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.legalButton.frame.size.height
        self.legalButton.frame = frame
        self.view.bringSubview(toFront: self.legalButton)
    }
    
    func createFloatyLegalAndPrivacyButton(){
        self.legalButton.frame = CGRect(x: self.view.bounds.minX + 8, y: self.view.bounds.maxY - 110, width: 50, height: 40)
        self.legalButton.layer.masksToBounds = true
        self.legalButton.backgroundColor = UIColor.clear
        self.legalButton.setTitleColor(UIColor.turnnWhite(), for: UIControlState())
        self.legalButton.setTitle("Legal &\nPrivacy", for: UIControlState())
        self.legalButton.titleLabel?.numberOfLines = 2
        self.legalButton.titleLabel?.textAlignment = .center
        self.legalButton.titleLabel?.font = UIFont.init(name: "Ubuntu", size: 11.0)
        self.legalButton.addTarget(self, action: #selector(legalButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.legalButton)
        self.view.bringSubview(toFront: self.legalButton)
    }
    
    func legalButtonTapped(){
    self.performSegue(withIdentifier: "myEventsToLegalSegue", sender: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myEventCell", for: indexPath) as? MyEventTableViewCell {
            let event = events[indexPath.row]
            cell.updateWithEvent(event)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = events[indexPath.row]
            EventController.sharedController.deleteEvent(event)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            events.remove(at: indexPath.row)
            tableView.endUpdates()
        }
    }
}
