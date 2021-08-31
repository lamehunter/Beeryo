//
//  RecipeEntity+CoreDataProperties.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//
//

import Foundation
import CoreData


extension RecipeEntity {
  
  @nonobjc public class func fetchRequest1() -> NSFetchRequest<RecipeEntity> {
    return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
  }
  
  @NSManaged public var bottling: NSObject?
  @NSManaged public var fermenting: NSObject?
  @NSManaged public var fg: Float
  @NSManaged public var hops: NSObject?
  @NSManaged public var malts: NSObject?
  @NSManaged public var mashing: NSObject?
  @NSManaged public var name: String?
  @NSManaged public var og: Float
  @NSManaged public var style: String?
  @NSManaged public var yeast: NSObject?
  
  static func createWith(recipeName: String, using viewContext: NSManagedObjectContext) {
    let recipe = RecipeEntity(context: viewContext)
    recipe.name = recipeName
    
    do {
      try viewContext.save()
    }
    catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}

extension RecipeEntity : Identifiable {
  
}
