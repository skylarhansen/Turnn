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
    
    @IBOutlet fileprivate var conditionalLabels: [UILabel]! {
        didSet {
            conditionalLabels.forEach {
                $0.isHidden = true
            }
        }
    }
    @IBOutlet fileprivate var conditionalFields: [UITextField]! {
        didSet {
            conditionalFields.forEach {
                $0.isHidden = true
            }
        }
    }
    
    @IBOutlet weak fileprivate var forgetPasswordButtonOutlet: UIButton!
    
    @IBOutlet weak fileprivate var haveAccountLabel: UILabel!
    @IBOutlet weak fileprivate var signUpOrInButtonOutlet: UIButton!
    
    @IBOutlet weak fileprivate var emailField: UITextField!
    @IBOutlet weak fileprivate var passwordField: UITextField!
    @IBOutlet weak fileprivate var firstNameField: UITextField!
    @IBOutlet weak fileprivate var lastNameField: UITextField!
    
    @IBOutlet weak fileprivate var centerYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak fileprivate var loginOrSignUpButtonOutlet: UIButton!
    
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
        forgetPasswordButtonOutlet.isHidden = false
        forgetPasswordButtonOutlet.isEnabled = true
        setDelegatesForTextFields()
        setupViewUI()
        haveAccountLabel.text = "Don't have an account?"
        loginOrSignUpButtonOutlet.setTitle("Login", for: UIControlState())
        signUpOrInButtonOutlet.setTitle("Sign Up", for: UIControlState())
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        if textField == emailField {
            return newLength <= 35
        } else if textField == passwordField {
            return newLength <= 25
        } else if textField == firstNameField {
            return newLength <= 25
        } else if textField == lastNameField {
            return newLength <= 25
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.centerYConstraint.constant = -65
            self.view.layoutIfNeeded()
        }) 
    }
    
    @IBAction func tappedOutsideTextFields(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.centerYConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) 
    }
    
    func setupViewUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.184, green: 0.184, blue: 0.184, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor.turnnBlue()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    func updateLoginView() {
        if isSignInPage == true  {
            UIView.animate(withDuration: 0.25, animations: {
                self.conditionalLabels.forEach {
                    $0.isHidden = false
                }
                self.conditionalFields.forEach {
                    $0.isHidden = false
                }
                self.haveAccountLabel.text = "Already have an account?"
            })
            forgetPasswordButtonOutlet.isHidden = true
            forgetPasswordButtonOutlet.isEnabled = false
            loginOrSignUpButtonOutlet.setTitle("Create Account", for: UIControlState())
            signUpOrInButtonOutlet.setTitle("Sign In", for: UIControlState())
            isSignInPage = false
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.conditionalLabels.forEach {
                    $0.isHidden = true
                }
                self.conditionalFields.forEach {
                    $0.isHidden = true
                }
                self.haveAccountLabel.text = "Don't have an account?"
            })
            forgetPasswordButtonOutlet.isHidden = false
            forgetPasswordButtonOutlet.isEnabled = true
            loginOrSignUpButtonOutlet.setTitle("Login", for: UIControlState())
            signUpOrInButtonOutlet.setTitle("Sign Up", for: UIControlState())
            isSignInPage = true
        }
    }
    
    func signUp() {
         if let firstName = firstNameField.text, firstNameField.text != "",
            let email = emailField.text, emailField.text != "",
            let password = passwordField.text, passwordField.text != "" {
            UserController.createUser(firstName, lastName: lastNameField.text ?? "", paid: false, email: email, password: password, completion: { (user, error) in
                UserController.shared.currentUser = user
                if UserController.shared.currentUser != nil {
                    self.performSegue(withIdentifier: "fromLoginToEventFinderSegue", sender: self)
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.firstNameField.text = ""
                    self.lastNameField.text = ""
                    self.updateLoginView()
                    self.loginOrSignUpButtonOutlet.isEnabled = true
                } else {
                    if error != nil {
                        if let errCode = AuthErrorCode(rawValue: error!.code) {
                            switch errCode {
                            case .tooManyRequests:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Too many recent account creation attempts from your device. Please wait a little while and try again.")
                            case .invalidEmail:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Invalid email address, please correct the address you entered and again.")
                            case .weakPassword:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Password is too short and/or weak. Please make your password at least eight characters,\nand include at least one upper-case letter, one lower-case letter, and one number")
                            case .emailAlreadyInUse:
                                self.createAlert("Error: \(errCode.rawValue)", message: "An account already exists for this email address. Please choose 'sign in' at the bottom of the page to login to your account.")
                            case .internalError:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Internal error. Please try again.")
                            case .networkError:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Not able to connect to the network. Please test your connection and try again.")
                            default:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Account creation failed due to an unexpected error. 💩")
                            }
                        }
                        self.loginOrSignUpButtonOutlet.isEnabled = true
                    }
                }
            })
         } else {
            self.loginOrSignUpButtonOutlet.isEnabled = true
        }
    }
    
    func login() {
         if let email = emailField.text, emailField.text != "",
            let password = passwordField.text, passwordField.text != "" {
            UserController.authUser(email, password: password, completion: { (user, error) in
                UserController.shared.currentUser = user
                if UserController.shared.currentUser != nil {
                    self.performSegue(withIdentifier: "fromLoginToEventFinderSegue", sender: self)
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.firstNameField.text = ""
                    self.lastNameField.text = ""
                    self.loginOrSignUpButtonOutlet.isEnabled = true
                } else {
                    if error != nil {
                        if let errCode = AuthErrorCode(rawValue: error!.code) {
                            switch errCode {
                            case .tooManyRequests:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Too many recent login attempts from your device. Please wait a little while and try again.")
                            case .invalidEmail:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Invalid email address, please try again.")
                            case .wrongPassword:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Invalid password, please try again. If you forgot your password, please use the 'forgot password' button below.")
                            case .userDisabled:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Your account has been disabled, likely for the creation of inappropriate events.")
                            case .internalError:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Internal error. Please try again.")
                            case .networkError:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Not able to connect to the network. Please test your connection and try again.")
                            case .userNotFound:
                                self.createAlert("Error: \(errCode.rawValue)", message: "User not found! The account may not exist yet. Choose 'sign up' at the bottom of the page to create an account.")
                            default:
                                self.createAlert("Error: \(errCode.rawValue)", message: "Login failed due to an unexpected error. 💩")
                            }
                        }
                       self.loginOrSignUpButtonOutlet.isEnabled = true
                    }
                }
            })
         } else {
            self.loginOrSignUpButtonOutlet.isEnabled = true
        }
    }
    
    @IBAction func toggleSignUpOrInButtonTapped(_ sender: AnyObject) {
        updateLoginView()
    }
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
            self.loginOrSignUpButtonOutlet.isEnabled = false
        if isSignInPage == false {
            signUp()
        } else {
            login()
        }
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: AnyObject) {
        let prompt = UIAlertController.init(title: "Reset Password", message: "Please enter the email address associated with your Turnn account:", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "Submit", style: UIAlertActionStyle.default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
            self.createAlert("Request Sent", message: "If address is associated with a Turnn account, you should receive a password reset email within a few minutes.")
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        prompt.addAction(cancelAction)
        present(prompt, animated: true, completion: nil)
    }
    
    func createAlert(_ title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
}
