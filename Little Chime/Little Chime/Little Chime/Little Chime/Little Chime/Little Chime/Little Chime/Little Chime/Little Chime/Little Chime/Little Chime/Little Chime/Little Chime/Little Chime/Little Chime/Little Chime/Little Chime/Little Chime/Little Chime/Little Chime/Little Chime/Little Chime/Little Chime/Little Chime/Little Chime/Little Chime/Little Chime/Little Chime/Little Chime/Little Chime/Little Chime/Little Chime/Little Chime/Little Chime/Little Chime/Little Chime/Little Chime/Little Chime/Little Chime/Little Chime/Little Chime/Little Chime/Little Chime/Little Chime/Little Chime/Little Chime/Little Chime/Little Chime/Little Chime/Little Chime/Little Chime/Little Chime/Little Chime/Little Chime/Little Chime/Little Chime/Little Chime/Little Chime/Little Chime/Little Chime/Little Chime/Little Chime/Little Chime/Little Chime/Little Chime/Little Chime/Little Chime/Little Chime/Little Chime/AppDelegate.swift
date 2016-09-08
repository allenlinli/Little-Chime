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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let soruceOption = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotationOption = options[UIApplicationOpenURLOptionsKey.annotation] as? String
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: soruceOption, annotation: annotationOption)
        {
            return true;
        }
        
        assert(false)
    }
}
