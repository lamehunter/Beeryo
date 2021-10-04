//
//  StepFermentationEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 04/10/2021.
//
//

import Foundation
import CoreData


extension StepFermentationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepFermentationEntity> {
        return NSFetchRequest<StepFermentationEntity>(entityName: "StepFermentationEntity")
    }

    @NSManaged public var temperature: Int16
    @NSManaged public var index: Int16
    @NSManaged public var duration: Int16
    @NSManaged public var note: String?
    @NSManaged public var recipe: RecipeEntity?

}

extension StepFermentationEntity : Identifiable {

}
