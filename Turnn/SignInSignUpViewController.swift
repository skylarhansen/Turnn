//
//  SignInSignUpViewController.swift
//  Turnn
//
//  Created by Steve Cox on 8/3/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class SignInSignUpViewController: UIViewController, UITextFieldDelegate {
    
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
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginOrSignUpButtonOutlet: UIButton!
    
    var isSignInPage = true
    
    
    let dummyLocation = Location(address: "341 S Main Street", city: "Salt Lake City", state: "UT", zipCode: "84111", latitude: 40.761819, longitude: -111.890561)
    
    let dummyUser = User(firstName: "Andrew", lastName: "Madsen", events: [], paid: true, identifier: "fake_id")
    
    func setDelegatesForTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegatesForTextFields()
        setupViewUI()
        haveAccountLabel.text = "Don't have an account?"
        loginOrSignUpButtonOutlet.setTitle("LOGIN", forState: .Normal)
        signUpOrInButtonOutlet.setTitle("Sign Up", forState: .Normal)

        
        // DUMMY EVENT CREATOR BELOW:
        
//        EventController.createEvent("test event", location: dummyLocation, startTime: NSDate(), endTime: NSDate().dateByAddingTimeInterval(30000), categories: [Categories.Drinking.rawValue, Categories.Hackathon.rawValue, Categories.VideoGames.rawValue], eventDescription: "this is the best event there ever was", passwordProtected: false, password: nil, price: 10750.00, contactInfo: "1-800-coolest-party", image: nil, host: dummyUser, moreInfo: "this party requires that you bring glow sticks", completion: { (success) in
//            
//            if success {
//                
//            } else {
//                print("CRAP THIS SUCKS.... (just give up)!")
//            }
//        })
        
        // GENERAL NETWORK CONNECTIVELY ERROR MESSAGE ALERT SETUP BELOW--BUT DIDN'T WORK WHEN IT WAS TESTED THU 11 AUG 6PM
        
//        if !Reachability.isConnectedToNetwork() {
//            self.createAlert("Connection Failed", message: "Not able to connect to the network. Please test you connection and try again.")
//        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5) {
            self.centerYConstraint.constant = -65
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func tappedOutsideTextFields(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        UIView.animateWithDuration(0.5) {
            self.centerYConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
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
            UIView.animateWithDuration(0.25){
                self.conditionalLabels.forEach {
                    $0.hidden = false
                }
                self.conditionalFields.forEach {
                    $0.hidden = false
                }
                self.haveAccountLabel.text = "Already have an account?"
            }
            loginOrSignUpButtonOutlet.setTitle("Create Account", forState: .Normal)
            signUpOrInButtonOutlet.setTitle("Sign In", forState: .Normal)
            isSignInPage = false
        } else {
            UIView.animateWithDuration(0.25){
                self.conditionalLabels.forEach {
                    $0.hidden = true
                }
                self.conditionalFields.forEach {
                    $0.hidden = true
                }
                self.haveAccountLabel.text = "Don't have an account?"
            }
            loginOrSignUpButtonOutlet.setTitle("Login", forState: .Normal)
            signUpOrInButtonOutlet.setTitle("Sign Up", forState: .Normal)
            isSignInPage = true
        }
    }
    
    func signUp() {
        if let firstName = firstNameField.text where firstNameField.text != "",
            let email = emailField.text where emailField.text != "",
            let password = passwordField.text where passwordField.text != "" {
            
            UserController.createUser(firstName, lastName: lastNameField.text ?? "", paid: false, email: email, password: password, completion: { (user, error) in
                UserController.shared.currentUser = user
                if UserController.shared.currentUser != nil {
                    self.performSegueWithIdentifier("fromLoginToEventFinderSegue", sender: self)
                } else {
                    if error != nil {
                        
                        if let errCode = FIRAuthErrorCode(rawValue: error!.code) {
                            
                            switch errCode {
                                
                            case .ErrorCodeInvalidEmail:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Invalid email address, please correct the address you entered and again.")
                            case .ErrorCodeWeakPassword:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Password is too short and/or weak. Please make your password at least eight characters,\nand include at least one upper-case letter, one lower-case letter, and one number")
                            case .ErrorCodeEmailAlreadyInUse:
                                self.createAlert("Error: \(errCode.rawValue)", message: "An account already exists for this email address. Please choose 'sign in' at the bottom of the page to login to your account.")
                            case .ErrorCodeInternalError:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Internal error. Please try again.")
                            case .ErrorCodeNetworkError:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Not able to connect to the network. Please test your connection and try again.")
                            default:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Login failed due to an unexpected error. 💩")
                            }
                        }
                    }
                }
            })
        }
    }
    
    func login() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        
        UserController.authUser(email, password: password, completion: { (user, error) in
            UserController.shared.currentUser = user
            if UserController.shared.currentUser != nil {
                self.performSegueWithIdentifier("fromLoginToEventFinderSegue", sender: self)
            } else {
                if error != nil {
                    
                    if let errCode = FIRAuthErrorCode(rawValue: error!.code) {
                        
                        switch errCode {
                            
                        case .ErrorCodeInvalidEmail:
                            self.createAlert("Error: \(errCode.rawValue)", message: "Invalid email address, please try again.")
                        case .ErrorCodeWrongPassword:
                            self.createAlert("Error: \(errCode.rawValue)", message: "Invalid password, please try again. If you forgot your password, please use the 'forgot password' button below.")
                        case .ErrorCodeUserDisabled:
                            self.createAlert("Error: \(errCode.rawValue)", message: "Your account has been disabled, likely for the creation of inappropriate events.")
                        case .ErrorCodeInternalError:
                            self.createAlert("Error: \(errCode.rawValue)", message: "Internal error. Please try again.")
                        case .ErrorCodeNetworkError:
                            self.createAlert("Error: \(errCode.rawValue)", message: "Not able to connect to the network. Please test your connection and try again.")
                        case .ErrorCodeUserNotFound:
                            self.createAlert("Error: \(errCode.rawValue)", message: "User not found! The account may not exist yet. Choose 'sign up' at the bottom of the page to create an account.")
                        default:
                            self.createAlert("Error: \(errCode.rawValue)", message: "Login failed due to an unexpected error. 💩")
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func toggleSignUpOrInButtonTapped(sender: AnyObject) {
        updateLoginView()
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if isSignInPage == false {
            
            signUp()
            
        } else {
            
            login()
        }
    }
    
    func createAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(okayAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}