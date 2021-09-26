//
//  RecipeEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var fg: Float
    @NSManaged public var name: String?
    @NSManaged public var og: Float
    @NSManaged public var style: String?
    @NSManaged public var malts: NSSet?

}

// MARK: Generated accessors for malts
extension RecipeEntity {

    @objc(addMaltsObject:)
    @NSManaged public func addToMalts(_ value: MaltEntity)

    @objc(removeMaltsObject:)
    @NSManaged public func removeFromMalts(_ value: MaltEntity)

    @objc(addMalts:)
    @NSManaged public func addToMalts(_ values: NSSet)

    @objc(removeMalts:)
    @NSManaged public func removeFromMalts(_ values: NSSet)

}

extension RecipeEntity : Identifiable {

}
