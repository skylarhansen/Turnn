//
//  LoadingScreenViewController.swift
//  Turnn
//
//  Created by Steve Cox on 9/29/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import Firebase

class LoadingScreenViewController: UIViewController {

    var isUserLoggedInOnServer: Bool?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        FIRApp.configure()
    }
    
    override func viewDidAppear(animated: Bool) {
        UserController.isLoggedInServerTest { (success, error) in
            if success == true {
                self.isUserLoggedInOnServer = true
                UserController.restoreUserIdToDevice()
                self.performSegueWithIdentifier("loadingScreenToEventFinderSegue", sender: nil)
                    self.activityIndicator.removeFromSuperview()
            } else {
                self.isUserLoggedInOnServer = false
                if UserController.shared.currentUser == nil || self.isUserLoggedInOnServer == false {
                self.performSegueWithIdentifier("loadingScreenToSignUpSignInSegue", sender: nil)
                    self.activityIndicator.removeFromSuperview()
                }
            }
        }
        NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 3))
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
