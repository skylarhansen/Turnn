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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setupViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.turnnGray()
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    @IBAction func doneButtonTapped(_ sender: AnyObject)
        {
            self.dismiss(animated: true, completion: nil)
        }

    
}
