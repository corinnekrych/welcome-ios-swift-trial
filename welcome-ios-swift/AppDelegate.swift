//
//  AppDelegate.swift
//  welcome-ios-swift
//
//  Created by Corinne Krych on 06/05/16.
//  Copyright © 2016 corinnekrych. All rights reserved.
//

import UIKit
import FeedHenry

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    public var initSuccess = false

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FH.init {(resp: Response, error: NSError?) -> Void in
            if let error = error {
                print("FH init failed. Error = \(error)")
                if FH.isOnline == false {
                    self.presentAlert("Offline", message: "Make sure you're online.")
                } else {
                   self.presentAlert("Missing Configuration", message: "Please fill in fhconfig.plist file.")
                }
                return
            }
            print("initialized OK")
            self.initSuccess = true
        }
        return true
    }
    
    public func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
}

