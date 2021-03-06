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
    
    override init () {
        
        FIRApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        
        self.getVersion()
        
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
    
    
    //Function for checking the current version of beer and bar server. If data task was successful, compare it to current version in core data. If version does not match, delete the old version and replace new one from server. Once version has been changed, we call getBars() function. If we do not have any version in core data, define the version to be 1.
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
    
    //Function for deleting current bars from core data and replacing them with new ones from server. Once we define new bars, we call getBeersForBar() function for each of them.
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
                            bar.latitude = jsonItem["latitude"] as! Double
                            bar.longitude = jsonItem["longitude"] as! Double
                            bar.location = jsonItem["location"] as? String
                            bar.uuid = jsonItem["uuid"] as? String
                            
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
    
    //Function for getting the list of beers for current bar.
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
                            beer.recommended = jsonItem["recommended"] as! Bool
                            beer.image = jsonItem["image"] as? String
                            beer.style = jsonItem["style"] as? String
                            beer.volume = jsonItem["volume"] as? String
                            beer.country = jsonItem["country"] as? String
                            
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

