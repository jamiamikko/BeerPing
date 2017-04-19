//
//  Bar+CoreDataProperties.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 12/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import Foundation
import CoreData


extension Bar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bar> {
        return NSFetchRequest<Bar>(entityName: "Bar")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var filename: String?
    @NSManaged public var beers: NSSet?

}

// MARK: Generated accessors for beers
extension Bar {

    @objc(addBeersObject:)
    @NSManaged public func addToBeers(_ value: Beer)

    @objc(removeBeersObject:)
    @NSManaged public func removeFromBeers(_ value: Beer)

    @objc(addBeers:)
    @NSManaged public func addToBeers(_ values: NSSet)

    @objc(removeBeers:)
    @NSManaged public func removeFromBeers(_ values: NSSet)

}
