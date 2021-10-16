//
//  StepMashingEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 16/10/2021.
//
//

import Foundation
import CoreData


extension StepMashingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepMashingEntity> {
        return NSFetchRequest<StepMashingEntity>(entityName: "StepMashingEntity")
    }

    @NSManaged public var duration: Int16
    @NSManaged public var index: Int16
    @NSManaged public var note: String?
    @NSManaged public var temperature: Int16
    @NSManaged public var recipe: RecipeEntity?

}

extension StepMashingEntity : Identifiable {

}
