//
//  User+CoreDataProperties.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 10/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}
