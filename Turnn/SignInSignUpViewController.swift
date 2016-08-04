//
//  SignInSignUpViewController.swift
//  Turnn
//
//  Created by Steve Cox on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit

class SignInSignUpViewController: UIViewController {
    
    @IBOutlet var conditionalLabels: [UILabel]! {
        didSet {
            conditionalLabels.forEach {
                $0.hidden = true
            }
        }
    }
    @IBOutlet var conditionalFields: [UITextField]! {
        didSet {
            conditionalFields.forEach {
                $0.hidden = true
            }
        }
    }
    
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var signUpOrInButtonOutlet: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    var isSignInPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewUI()
 
        createAccountButton.enabled = false
        createAccountButton.hidden = true
        haveAccountLabel.text = "Don't have an account?"
        signUpOrInButtonOutlet.setTitle("Sign Up", forState: .Normal)
    }
    
    func setupViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.278, green: 0.310, blue: 0.310, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.000, green: 0.663, blue: 0.800, alpha: 1.00)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        setBackgroundForView()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setBackgroundForView() {
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        let imageView = UIImageView(image: UIImage(named: "Turnn Background")!)
        imageView.contentMode = .Center
        
        imageView.addSubview(blurView)
        self.view.insertSubview(imageView, atIndex: 0)
        blurView.frame = imageView.frame
    }
    
    func updateLoginView() {
        if isSignInPage == true  {
            conditionalLabels.forEach {
                $0.hidden = false
            }
            conditionalFields.forEach {
                $0.hidden = false
            }
            haveAccountLabel.text = "Already have an account?"
            signUpOrInButtonOutlet.setTitle("Sign In", forState: .Normal)
            isSignInPage = false
        } else {
            conditionalLabels.forEach {
                $0.hidden = true
            }
            conditionalFields.forEach {
                $0.hidden = true
            }
            haveAccountLabel.text = "Don't have an account?"
            signUpOrInButtonOutlet.setTitle("Sign Up", forState: .Normal)
            isSignInPage = true
        }
    }
    
    var createAccountButtonVisible: Bool = true {
        didSet {
            
            if isSignInPage == false && emailField.text != "" && passwordField != "" && firstNameField != "" {
                createAccountButton.hidden = false
                createAccountButton.enabled = true
            } else {
                createAccountButton.enabled = false
                createAccountButton.hidden = true
            }
        }
    }
    
    @IBAction func toggleSignUpOrInButtonTapped(sender: AnyObject) {
        updateLoginView()
    }
    
    @IBAction func createAccountButtonTapped(sender: AnyObject) {
        
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
