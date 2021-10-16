//
//  YeastEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 16/10/2021.
//
//

import Foundation
import CoreData


extension YeastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YeastEntity> {
        return NSFetchRequest<YeastEntity>(entityName: "YeastEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var recipe: RecipeEntity?

}

extension YeastEntity : Identifiable {

}
