//
//  AppDelegate.swift
//  Little Chime
//
//  Created by allenlinli on 8/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let soruceOption = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotationOption = options[UIApplicationOpenURLOptionsKey.annotation] as? String
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: soruceOption, annotation: annotationOption) {
            return true
        }
        else if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: soruceOption, annotation: annotationOption) {
            return true
        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    
}
