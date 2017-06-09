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

class FirebaseObserver {
    
    var refHandler: FIRDatabaseHandle!
    var barsRef = FIRDatabase.database().reference()
    
    init() {
        
        self.barsRef = barsRef.child("bars")
        
    }
    
    func observe() {
        refHandler = barsRef.observe(.value, with: { barSnapshot in
            
            self.getBars(barSnapshot: barSnapshot)
            
        })
    }
    
    func getBars(barSnapshot: FIRDataSnapshot) {
        
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
                
                for attribute in bar.children {
                    
                    let barAttribute = attribute as! FIRDataSnapshot
                    
                    switch barAttribute.key {
                    case "beers":
                        
                        for beer in barAttribute.value as! [AnyObject] {
                            let beerAttributes: Dictionary<String, Any> = beer as! Dictionary
                            
                            self.getBeers(currentBar: barObject, beerAttributes: beerAttributes)
                        }
                    case "id":
                        barObject.id = barAttribute.value as! Int16
                        
                    case "latitude":
                        barObject.latitude = barAttribute.value as! Double
                        
                    case "location":
                        barObject.location = barAttribute.value as? String
                        
                    case "longitude":
                        barObject.longitude = barAttribute.value as! Double
                        
                    case "name":
                        barObject.name = barAttribute.value as? String
                        
                    case "uuid":
                        barObject.uuid = barAttribute.value as? String
                        
                    case "type":
                        barObject.type = barAttribute.value as? String
                        
                    default:
                        print("could not recognize \(barAttribute.key): \(barAttribute.value!)")
                    }
                    
                    
                }
                
                DatabaseController.saveContext()
                
            }
    
    }
    
    func getBeers(currentBar: Bar, beerAttributes: Dictionary<String, Any>) {
        
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
        
        currentBar.addToBeers(beerObject)
        DatabaseController.saveContext()
    }
}
