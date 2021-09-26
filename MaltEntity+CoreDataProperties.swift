//
//  MaltEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//
//

import Foundation
import CoreData


extension MaltEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MaltEntity> {
        return NSFetchRequest<MaltEntity>(entityName: "MaltEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var weight: Float
    @NSManaged public var recipe: RecipeEntity?

}

extension MaltEntity : Identifiable {

}
