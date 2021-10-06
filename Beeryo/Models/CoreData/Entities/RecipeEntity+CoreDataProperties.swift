//
//  RecipeEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 04/10/2021.
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
    @NSManaged public var hops: NSSet?
    @NSManaged public var malts: NSSet?
    @NSManaged public var yeasts: NSSet?
    @NSManaged public var boilDetails: BoilEntity?
    @NSManaged public var stepsFermenting: NSSet?
    @NSManaged public var stepsMashing: NSSet?
    @NSManaged public var additions: NSSet?

}

// MARK: Generated accessors for hops
extension RecipeEntity {

    @objc(addHopsObject:)
    @NSManaged public func addToHops(_ value: HopsEntity)

    @objc(removeHopsObject:)
    @NSManaged public func removeFromHops(_ value: HopsEntity)

    @objc(addHops:)
    @NSManaged public func addToHops(_ values: NSSet)

    @objc(removeHops:)
    @NSManaged public func removeFromHops(_ values: NSSet)

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

// MARK: Generated accessors for yeasts
extension RecipeEntity {

    @objc(addYeastsObject:)
    @NSManaged public func addToYeasts(_ value: YeastEntity)

    @objc(removeYeastsObject:)
    @NSManaged public func removeFromYeasts(_ value: YeastEntity)

    @objc(addYeasts:)
    @NSManaged public func addToYeasts(_ values: NSSet)

    @objc(removeYeasts:)
    @NSManaged public func removeFromYeasts(_ values: NSSet)

}

// MARK: Generated accessors for stepsFermenting
extension RecipeEntity {

    @objc(addStepsFermentingObject:)
    @NSManaged public func addToStepsFermenting(_ value: StepFermentationEntity)

    @objc(removeStepsFermentingObject:)
    @NSManaged public func removeFromStepsFermenting(_ value: StepFermentationEntity)

    @objc(addStepsFermenting:)
    @NSManaged public func addToStepsFermenting(_ values: NSSet)

    @objc(removeStepsFermenting:)
    @NSManaged public func removeFromStepsFermenting(_ values: NSSet)

}

// MARK: Generated accessors for stepsMashing
extension RecipeEntity {

    @objc(addStepsMashingObject:)
    @NSManaged public func addToStepsMashing(_ value: StepMashingEntity)

    @objc(removeStepsMashingObject:)
    @NSManaged public func removeFromStepsMashing(_ value: StepMashingEntity)

    @objc(addStepsMashing:)
    @NSManaged public func addToStepsMashing(_ values: NSSet)

    @objc(removeStepsMashing:)
    @NSManaged public func removeFromStepsMashing(_ values: NSSet)

}

// MARK: Generated accessors for additions
extension RecipeEntity {

    @objc(addAdditionsObject:)
    @NSManaged public func addToAdditions(_ value: AdditionEntity)

    @objc(removeAdditionsObject:)
    @NSManaged public func removeFromAdditions(_ value: AdditionEntity)

    @objc(addAdditions:)
    @NSManaged public func addToAdditions(_ values: NSSet)

    @objc(removeAdditions:)
    @NSManaged public func removeFromAdditions(_ values: NSSet)

}

extension RecipeEntity : Identifiable {

}
