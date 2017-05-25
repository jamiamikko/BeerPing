//
//  CurrentVersion+CoreDataProperties.swift
//  
//
//  Created by Mikko Jämiä on 25/05/2017.
//
//

import Foundation
import CoreData


extension CurrentVersion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentVersion> {
        return NSFetchRequest<CurrentVersion>(entityName: "CurrentVersion")
    }

    @NSManaged public var version: Int32

}
