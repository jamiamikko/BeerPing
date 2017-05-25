//
//  AppDelegate.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 03/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import CoreData
import CoreTelephony
import CoreLocation
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    
    var fetchedResultsController = NSFetchedResultsController<Bar>()
    
    override init () {
        
        FIRApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        
        
        //Create variable which initializes the appearance of the navigation bar
        let navigationBarAppearance = UINavigationBar.appearance()
        
        //Set background color of navigation bar
        navigationBarAppearance.tintColor = uiColorFromHex(rgbValue: 0xFFFFFF)
        
        //Set button tint colors of the navigation bar
        navigationBarAppearance.barTintColor = uiColorFromHex(rgbValue: 0x173B47)
        
        //Change the color of the status bar
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //Change navigation bar title color, font-family and font size
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        let firebController: FirebaseController = FirebaseController()
        
        DatabaseController.saveContext()
        
        firebController.getBars()
        
        
        return true
    }
    
    //Convert RBG values to Hex
    func uiColorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

