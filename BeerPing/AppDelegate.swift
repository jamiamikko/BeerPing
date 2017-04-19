//
//  AppDelegate.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 03/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.getVersion()
        
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
        
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
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
                        
                        
                        
                        if json["version"] != nil {
                            let fetchRequest:NSFetchRequest<CurrentVersion> = CurrentVersion.fetchRequest()
                            
                            do {
                                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                                
                                if searchResults.count != 0 {
                                    for result in searchResults as [CurrentVersion] {
                                    
                                        print(result.version)
                                        
                                        if result.version != json["version"] as! Int32 {
                                            
                                            DatabaseController.getContext().delete(result)
                                            
                                            let versionClassName:String = String(describing: CurrentVersion.self)
                                            
                                            let currentVersion: CurrentVersion = NSEntityDescription.insertNewObject(forEntityName: versionClassName, into: DatabaseController.getContext()) as! CurrentVersion
                                            
                                            currentVersion.version = json["version"] as! Int32
                                            
                                            DatabaseController.saveContext()
                                            
                                            self.getBars()

                                        }
                                    }
                                } else {
                                    let versionClassName:String = String(describing: CurrentVersion.self)
                                    
                                    let currentVersion: CurrentVersion = NSEntityDescription.insertNewObject(forEntityName: versionClassName, into: DatabaseController.getContext()) as! CurrentVersion
                                    
                                    currentVersion.version = 1
                                    
                                    DatabaseController.saveContext()
                                    
                                    self.getBars()
                                }
                            } catch {
                                print("Error: \(error)")
                            }
                            
                            
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
        
        let fetchRequest:NSFetchRequest<Bar> = Bar.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            for result in searchResults as [Bar] {
                DatabaseController.getContext().delete(result)
            }
        } catch {
            print("Error: \(error)")
        }
        
        DatabaseController.saveContext()
    
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
                            
                            let barClassName:String = String(describing: Bar.self)
                            
                            let bar: Bar = NSEntityDescription.insertNewObject(forEntityName: barClassName, into: DatabaseController.getContext()) as! Bar
                            
                            bar.id = jsonItem["id"] as! Int16
                            bar.name = jsonItem["name"] as? String
                            bar.filename = jsonItem["filename"] as? String
                            
                            DatabaseController.saveContext()
                            
                            self.getBeersForBar(currentBar: bar)
                        
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
    
    func getBeersForBar(currentBar: Bar) {
        
        
        let url = URL(string: "http://users.metropolia.fi/~ottoja/beerbluds/\(currentBar.filename ?? "voeh")")
        
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
                        let beerJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                        
                        for jsonItem in beerJson {
                            
                            print(jsonItem["name"] ?? "none")
                            
                            let beerClassName:String = String(describing: Beer.self)
                            
                            let beer: Beer = NSEntityDescription.insertNewObject(forEntityName: beerClassName, into: DatabaseController.getContext()) as! Beer
                            
                            beer.abv = jsonItem["abv"] as! Float
                            beer.brewer = jsonItem["brewery"] as? String
                            beer.desc = jsonItem["description"] as? String
                            beer.ibu = jsonItem["ibu"] as! Int16
                            beer.id = jsonItem["id"] as! Int16
                            beer.name = jsonItem["name"] as? String
                            beer.price = jsonItem["price"] as? String
                            beer.type = jsonItem["type"] as? String
                            
                            currentBar.addToBeers(beer)
                            
                            DatabaseController.saveContext()
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

