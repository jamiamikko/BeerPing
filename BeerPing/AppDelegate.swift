//
//  AppDelegate.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 03/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import CoreData
//import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var locationManager: CLLocationManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        getVersion()
        
        //Create variable which initializes the appearance of the navigation bar
        let navigationBarAppearace = UINavigationBar.appearance()
        
        //Set background color of navigation bar
        navigationBarAppearace.tintColor = uiColorFromHex(rgbValue: 0xFFFFFF)
        
        //Set button tint colors of the navigation bar
        navigationBarAppearace.barTintColor = uiColorFromHex(rgbValue: 0x173B47)
        
        //Change the color of the status bar
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //Change navigation bar title color, font-family and font size
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        
        //locationManager = CLLocationManager()
        //locationManager?.requestWhenInUseAuthorization()
        
        
        
        return true
    }
    
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
    
    func getVersion() {
        let url = URL(string: "http://users.metropolia.fi/~ottoja/beerbluds/version.json")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print ("ERROR")
            }
            else{
                if let content = data
                {
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                        
                        
                        let fetchRequest:NSFetchRequest<CurrentVersion> = CurrentVersion.fetchRequest()
                        
                        do {
                            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                            
                            for result in searchResults as [CurrentVersion] {
                                print("\(result.version)")
                                
                                if json["version"] as! Int32 != result.version {
                                    result.version = json["version"] as! Int32
                                    DatabaseController.saveContext()
                                }
                                
                            }
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                        
                    catch{
                        print("error")
                    }
                }
            }
        }
        task.resume()

    }
    
    func getBars() {
        
        let url = URL(string: "http://users.metropolia.fi/~ottoja/beerbluds/bars.json")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print ("ERROR")
            }
            else{
                if let content = data
                {
                    do
                    {
                        let barJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                        
                        for jsonItem in barJson {                            
                            
                            print(jsonItem["name"] ?? "none")
                        }
                        
                    }
                        
                    catch{
                        print("error")
                    }
                }
            }
        }
        task.resume()
        
    }


}

