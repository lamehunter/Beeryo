//
//  RecipeEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 14/09/2021.
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

}

extension RecipeEntity : Identifiable {

}
