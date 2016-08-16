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
    
    @IBOutlet weak var forgetPasswordButtonOutlet: UIButton!
    
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var signUpOrInButtonOutlet: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginOrSignUpButtonOutlet: UIButton!
    
    var isSignInPage = true
    
    //let dummyLocation = Location(address: "341 S Main Street", city: "Salt Lake City", state: "UT", zipCode: "84111", latitude: 40.761819, longitude: -111.890561)
    
    //let dummyUser = User(firstName: "Andrew", lastName: "Madsen", events: [], paid: true, identifier: "fake_id")
    
    func setDelegatesForTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgetPasswordButtonOutlet.hidden = false
        forgetPasswordButtonOutlet.enabled = true
        setDelegatesForTextFields()
        setupViewUI()
        haveAccountLabel.text = "Don't have an account?"
        loginOrSignUpButtonOutlet.setTitle("Login", forState: .Normal)
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
    
    static func unwindToSignIn(segue: UIStoryboardSegue) {
        
    }
    
    
    func setupViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.184, green: 0.184, blue: 0.184, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
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
            forgetPasswordButtonOutlet.hidden = true
            forgetPasswordButtonOutlet.enabled = false
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
            forgetPasswordButtonOutlet.hidden = false
            forgetPasswordButtonOutlet.enabled = true
            loginOrSignUpButtonOutlet.setTitle("Login", forState: .Normal)
            signUpOrInButtonOutlet.setTitle("Sign Up", forState: .Normal)
            isSignInPage = true
        }
    }
    
    func signUp(completion: (success: Bool) -> Void) {
        
        if let firstName = firstNameField.text where firstNameField.text != "",
            let email = emailField.text where emailField.text != "",
            let password = passwordField.text where passwordField.text != "" {
            UserController.createUser(firstName, lastName: lastNameField.text ?? "", paid: false, email: email, password: password, completion: { (user, error) in
                UserController.shared.currentUser = user
                if UserController.shared.currentUser != nil {
                    completion(success: true)
                    self.performSegueWithIdentifier("fromLoginToEventFinderSegue", sender: self)
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.firstNameField.text = ""
                    self.lastNameField.text = ""
                    self.updateLoginView()
                } else {
                    if error != nil {
                        if let errCode = FIRAuthErrorCode(rawValue: error!.code) {
                            switch errCode {
                            case .ErrorCodeTooManyRequests:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Too many recent account creation attempts from your device. Please wait a little while and try again.")
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
                                self.createAlert("Error: \(errCode.rawValue)", message: "Account creation failed due to an unexpected error. 💩")
                            }
                        }
                    }
                    completion(success: false)
                }
            })
        }
        completion(success: false)
    }
    
    func login(completion: (winsuccess: Bool) -> Void) {
        
        if let email = emailField.text where emailField.text != "",
            let password = passwordField.text where passwordField.text != "" {
            UserController.authUser(email, password: password, completion: { (user, error) in
                UserController.shared.currentUser = user
                if UserController.shared.currentUser != nil {
                    completion(winsuccess: true)
                    self.performSegueWithIdentifier("fromLoginToEventFinderSegue", sender: self)
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.firstNameField.text = ""
                    self.lastNameField.text = ""
                } else {
                    if error != nil {
                        if let errCode = FIRAuthErrorCode(rawValue: error!.code) {
                            switch errCode {
                            case .ErrorCodeTooManyRequests:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Too many recent login attempts from your device. Please wait a little while and try again.")
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
                    completion(winsuccess: false)
                }
            })
        }
        completion(winsuccess: false)
    }
    
    
    @IBAction func toggleSignUpOrInButtonTapped(sender: AnyObject) {
        updateLoginView()
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
            self.loginOrSignUpButtonOutlet.enabled = false
        
        if isSignInPage == false {
    
            signUp({ (success) in
                if success == true {
                    
                    let seconds = 3.0
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        self.loginOrSignUpButtonOutlet.enabled = true
                    })
                    
                }
                
                if success == false {
                    
                    self.loginOrSignUpButtonOutlet.enabled = true
                }
                
            })
        } else {
            login({ (success) in
                if success == true {
    
                    let seconds = 3.0
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        self.loginOrSignUpButtonOutlet.enabled = true
                    })
                    
                }
                
                if success == false {
                    
                    self.loginOrSignUpButtonOutlet.enabled = true
                }
            })
        }
    }
    
    @IBAction func forgetPasswordButtonTapped(sender: AnyObject) {
        let prompt = UIAlertController.init(title: "Reset Password", message: "Please enter the email address associated with your Turnn account:", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction.init(title: "Submit", style: UIAlertActionStyle.Default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordResetWithEmail(userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
            self.createAlert("Request Sent", message: "If address is associated with a Turnn account, you should receive a password reset email within a few minutes.")
        }
        prompt.addTextFieldWithConfigurationHandler(nil)
        prompt.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        prompt.addAction(cancelAction)
        presentViewController(prompt, animated: true, completion: nil)
    }
    func createAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(okayAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}