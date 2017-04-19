//
//  Beer+CoreDataProperties.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 19/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import Foundation
import CoreData


extension Beer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Beer> {
        return NSFetchRequest<Beer>(entityName: "Beer")
    }

    @NSManaged public var abv: Float
    @NSManaged public var brewer: String?
    @NSManaged public var desc: String?
    @NSManaged public var ibu: Int16
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var type: String?
    @NSManaged public var bars: NSSet?

}

// MARK: Generated accessors for bars
extension Beer {

    @objc(addBarsObject:)
    @NSManaged public func addToBars(_ value: Bar)

    @objc(removeBarsObject:)
    @NSManaged public func removeFromBars(_ value: Bar)

    @objc(addBars:)
    @NSManaged public func addToBars(_ values: NSSet)

    @objc(removeBars:)
    @NSManaged public func removeFromBars(_ values: NSSet)

}
