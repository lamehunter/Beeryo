//
//  AdditionEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 16/10/2021.
//
//

import Foundation
import CoreData


extension AdditionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdditionEntity> {
        return NSFetchRequest<AdditionEntity>(entityName: "AdditionEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var weight: Int16
    @NSManaged public var duration: Int32
    @NSManaged public var recipe: RecipeEntity?

}

extension AdditionEntity : Identifiable {

}
