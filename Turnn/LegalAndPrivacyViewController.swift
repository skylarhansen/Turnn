//
//  LegalAndPrivacyViewController.swift
//  Turnn
//
//  Created by Steve Cox on 9/22/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class LegalAndPrivacyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setupViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.turnnGray()
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    @IBAction func doneButtonTapped(sender: AnyObject)
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    
}
