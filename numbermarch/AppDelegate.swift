//
//  AppDelegate.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/05/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Open first view
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let module = AppModules.calculator.build()
        module.router.show(inWindow: self.window, embedInNavController: false, setupData: nil, makeKeyAndVisible: true)

        return true
    }

}

