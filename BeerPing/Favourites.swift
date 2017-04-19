//
//  Favourites.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 05/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class Favourites: NSObject {
    
    var favouritesList: Set<Beer>
    
    init(list: Set<Beer>) {
        self.favouritesList = list
    }
    
    func getFavourites() -> Set<Beer> {
        return self.favouritesList
    }
    
    func setNewFavourite(newBeer: Beer) {
        favouritesList.insert(newBeer)
    }
    
}
