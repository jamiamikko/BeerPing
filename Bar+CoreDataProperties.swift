//
//  Bar+CoreDataProperties.swift
//  
//
//  Created by Mikko Jämiä on 25/05/2017.
//
//

import Foundation
import CoreData


extension Bar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bar> {
        return NSFetchRequest<Bar>(entityName: "Bar")
    }

    @NSManaged public var id: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var location: String?
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var uuid: String?
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
