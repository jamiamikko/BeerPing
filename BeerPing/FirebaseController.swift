//
//  FirebaseController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 19/05/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import Firebase

class FirebaseController {

    let rootRef = FIRDatabase.database().reference()
    let refHandle: FIRDatabaseHandle!
    
    init() {
        
        var ref = rootRef.child("bars")
        
        refHandle = ref.observe(.value, with: { barSnapshot in
            for child in barSnapshot.children {
                
                let element = child as! FIRDataSnapshot //each child is a snapshot

                
                for thing in element.children {
                    let currentThing = thing as! FIRDataSnapshot
                    
                    if currentThing.children != nil {
                        
                        for thirdThing in currentThing.children {
                            
                            let beer = thirdThing as! FIRDataSnapshot
                            
                            print("key: \(beer.key)")
                            print("value: \(beer.value!)")
                        }
                    }
                    
                    print("key: \(currentThing.key)")
                    print("value: \(currentThing.value!)")
                    
                }
            }
        })
    }
}
