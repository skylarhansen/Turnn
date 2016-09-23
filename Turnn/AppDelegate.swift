//
//  AppDelegate.swift
//  Turnn
//
//  Created by Skylar Hansen on 8/1/16.
//  Copyright © 2016 Skylar Hansen. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isUserLoggedInOnServer: Bool?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        FIRApp.configure()
        
        var value: Bool = false
        UserController.isLoggedInServerTest { (success, error) in
            if success == true && UserController.shared.currentUser != nil{
                self.isUserLoggedInOnServer = true
                sleep(2)
                value = true
            } else {
                self.isUserLoggedInOnServer = false
                if UserController.shared.currentUser == nil || self.isUserLoggedInOnServer == false {
                    let storyboard = UIStoryboard(name: "SignInSignUp", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("SignInSignUp")
                    self.window?.rootViewController = vc
                }
                value = false
            }
            
        }
        NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 4.0))
        return value
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
