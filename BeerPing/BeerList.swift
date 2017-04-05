//
//  BeerList.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 05/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class BeerList: NSObject {
    
    var beerList: Set<Beer>
    
    init(list: Set<Beer>) {
        self.beerList = list
    }
    
    func getFavourites() -> Set<Beer> {
        return self.beerList
    }
    
    func filterByRecommend() {
        print("Filtter by recommendation")
    }
    
    func filterByTap () {
        print("Filtter by tap")
    }
    
    func filterByBottle () {
        print("Filtter by bottle")
    }

}
