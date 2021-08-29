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
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
    return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
  }
  
  @NSManaged public var recipeName: String?
  
  static func createWith(recipeName: String, using viewContext: NSManagedObjectContext) {
    let recipe = RecipeEntity(context: viewContext)
    recipe.recipeName = recipeName
    
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
