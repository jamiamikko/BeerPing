//
//  Beer.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 05/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class Beer: NSObject {
    
    var name: String
    var brewery: String
    var desc: String
    var abv: String
    var type: String
    var price: String
    var ibu: String
    var id: Int
    
    init(name: String, brewery: String, desc: String, abv: String, type: String, price: String, ibu: String, id: Int) {
        self.name = name
        self.brewery = brewery
        self.desc = desc
        self.abv = abv
        self.type = type
        self.price = price
        self.ibu = ibu
        self.id = id
    
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getBrewery() -> String {
        return self.brewery
    }
    
    func getDescription() -> String {
        return self.desc
    }
    
    func getAbv() -> String {
        return self.abv
    }
    
    func getType() -> String {
        return self.type
    }
    
    func getPrice() -> String {
        return self.price
    }
    
    func getIbu() -> String {
        return self.ibu
    }
    
    func getId() -> Int {
        return self.id
    }
}
