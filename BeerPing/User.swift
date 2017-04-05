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
    let id: Int
    var favourites: Set<Beer>
    
    init(name: String, id: Int, favourites: Set<Beer>) {
        self.name = name
        self.favourites = favourites
        self.id = id
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
    
    func getFavourites() -> Set<Beer> {
        return self.favourites
    }
}
