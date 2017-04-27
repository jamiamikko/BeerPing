//
//  Beer+CoreDataProperties.swift
//  BeerPing
//
//  Created by iosdev on 26.4.2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import Foundation
import CoreData


extension Beer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Beer> {
        return NSFetchRequest<Beer>(entityName: "Beer");
    }

    @NSManaged public var abv: Float
    @NSManaged public var brewer: String?
    @NSManaged public var desc: String?
    @NSManaged public var ibu: Int16
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var type: String?
    @NSManaged public var recommended: Bool
    @NSManaged public var bar: Bar?

}
