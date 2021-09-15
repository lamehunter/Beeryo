//
//  PersistenceController.swift
//  Beeryo
//
//  Created by Jacek K on 15/09/2021.
//

import CoreData

final class PersistenceController: ObservableObject {
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  @Published var allRecipes: [RecipeEntity] = []
  
  init() {
    let containerName = "RecipeContainer"
    
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Failed to load container: \(error)")
      }
      else {
        print("Successfully loaded container - \(containerName)")
      }
    }
    getAllRecipes()
  }
  
  func getAllRecipes() {
    let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    do {
      allRecipes = try container.viewContext.fetch(request)
    }
    catch let error {
      print("Error to fetch all recipes: \(error)")
    }
  }
  
  //addREcipe
//  func addRecipe(_recipe: RecipeEntity) {
//    //let recipe = RecipeEntity(context: container.viewContext)
//    //recipe.name = _recipe.name
//    //recipe.og = _recipe.og
//    //recipe.fg = _recipe.fg
//    saveData()
//  }
  
  func deleteRecipe(indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    let entity = allRecipes[index]
    container.viewContext.delete(entity)
    saveData()
  }
  
  func saveData() {
    do {
      try container.viewContext.save()
      getAllRecipes()
    }
    catch let error {
      print("Error to save recipe: \(error)")
    }
  }
}
