//
//  HopsEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 16/10/2021.
//
//

import Foundation
import CoreData


extension HopsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HopsEntity> {
        return NSFetchRequest<HopsEntity>(entityName: "HopsEntity")
    }

    @NSManaged public var duration: Int32
    @NSManaged public var name: String?
    @NSManaged public var weight: Int32
    @NSManaged public var recipe: RecipeEntity?

}

extension HopsEntity : Identifiable {

}
