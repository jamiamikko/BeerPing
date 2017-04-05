//
//  User.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 05/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String!
    let id: Int = 1
    var favourites: Array<Any>
    
    init(name: String) {
        self.name = name
        self.favourites = []
    }
    
    func setName(newName: String) {
        self.name = newName
    
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getId() -> Int {
        return self.id
    }
    
    func getFavourites() -> Array<Any> {
        return self.favourites
    }
}
