//
//  BoilEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 16/10/2021.
//
//

import Foundation
import CoreData


extension BoilEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BoilEntity> {
        return NSFetchRequest<BoilEntity>(entityName: "BoilEntity")
    }

    @NSManaged public var duration: Int16
    @NSManaged public var note: String?
    @NSManaged public var recipe: RecipeEntity?

}

extension BoilEntity : Identifiable {

}
