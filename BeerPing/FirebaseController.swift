//
//  FirebaseController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 19/05/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class FirebaseController {
    
    let rootRef = FIRDatabase.database().reference()
    var refHandler: FIRDatabaseHandle!
    var barsRef = FIRDatabase.database().reference()
    
    init() {
        
        self.barsRef = rootRef.child("bars")
        
    }
    
    
    func getBars() {
        
        refHandler = barsRef.observe(.value, with: { barSnapshot in
            
            let fetchRequest:NSFetchRequest<Bar> = Bar.fetchRequest()
            
            do {
                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                
                for result in searchResults as [Bar] {
                    DatabaseController.getContext().delete(result)
                }
            } catch {
                print("Error: \(error)")
            }

            
            for element in barSnapshot.children {
                
                let bar = element as! FIRDataSnapshot //each child is a snapshot
                let barClassName:String = String(describing: Bar.self)
                let barObject: Bar = NSEntityDescription.insertNewObject(forEntityName: barClassName, into: DatabaseController.getContext()) as! Bar
                
                
                print("bar ID: \(bar.key)")
                
                for attribute in bar.children {
                    
                    let barAttribute = attribute as! FIRDataSnapshot
                    
                    switch barAttribute.key {
                    case "beers":
                        print("voeh")
                        
                        for beer in barAttribute.value as! [AnyObject] {
                            let beerAttributes: Dictionary<String, Any> = beer as! Dictionary
                            
                            let beerClassName:String = String(describing: Beer.self)
                            let beerObject: Beer = NSEntityDescription.insertNewObject(forEntityName: beerClassName, into: DatabaseController.getContext()) as! Beer
                            
                            for (key, value) in beerAttributes {
                                
                                switch key {
                                case "abv":
                                    beerObject.abv = value as! Float
                                case "brewery":
                                    beerObject.brewer = value as? String
                                case "country":
                                    beerObject.country = value as? String
                                case "description":
                                    beerObject.desc = value as? String
                                case "ibu":
                                    beerObject.ibu = value as! Int16
                                case "id":
                                    beerObject.id = value as! Int16
                                case "image":
                                    beerObject.image = value as? String
                                case "name":
                                    beerObject.name = value as? String
                                case "price":
                                    beerObject.price = value as? String
                                case "recommended":
                                    beerObject.recommended = value as! Bool
                                case "style":
                                    beerObject.style = value as? String
                                case "type":
                                    beerObject.type = value as? String
                                case "volume":
                                    beerObject.volume = value as? String
                                default:
                                    print("could not recognize \(key): \(value)")
                                    
                                }
                            }
                            
                            barObject.addToBeers(beerObject)
                            DatabaseController.saveContext()
                        }
                    case "id":
                        print("id is \(barAttribute.value!)")
                        barObject.id = barAttribute.value as! Int16
                        
                    case "latitude":
                        print("latitude is \(barAttribute.value!)")
                        barObject.latitude = barAttribute.value as! Double
                        
                    case "location":
                        print("location is \(barAttribute.value!)")
                        barObject.location = barAttribute.value as? String
                        
                    case "longitude":
                        print("longitude is \(barAttribute.value!)")
                        barObject.longitude = barAttribute.value as! Double
                        
                    case "name":
                        print("name is \(barAttribute.value!)")
                        barObject.name = barAttribute.value as? String
                        
                    case "uuid":
                        print("uuid is \(barAttribute.value!)")
                        barObject.uuid = barAttribute.value as? String
                        
                    default:
                        print("could not recognize \(barAttribute.key): \(barAttribute.value!)")
                    }
                    
                    
                }
                
                DatabaseController.saveContext()
                
                
            }
        })
    
    }
    
}
