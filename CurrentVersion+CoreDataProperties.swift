//
//  CurrentVersion+CoreDataProperties.swift
//  BeerPing
//
//  Created by iosdev on 3.5.2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import Foundation
import CoreData


extension CurrentVersion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentVersion> {
        return NSFetchRequest<CurrentVersion>(entityName: "CurrentVersion");
    }

    @NSManaged public var version: Int32

}
