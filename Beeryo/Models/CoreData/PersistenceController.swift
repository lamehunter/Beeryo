//
//  PersistenceController.swift
//  Beeryo
//
//  Created by Jacek K on 15/09/2021.
//

import CoreData

final class PersistenceController: ObservableObject {
  static let shared = PersistenceController()
  
  var container: NSPersistentContainer
  @Published var allRecipes: [RecipeEntity] = []
  
  static var preview: PersistenceController = {
    let controller = PersistenceController(inMemory: true)
    for number in 0..<10 {
      let recipe = RecipeEntity(context: controller.container.viewContext)
      recipe.name = "Recipe no." + String(number)
      controller.addRecipe(_recipe: recipe)
    }
    return controller
  }()
  
  init(inMemory: Bool = true) {
    
    let containerName = "RecipeContainer"
    
    container = NSPersistentContainer(name: containerName, managedObjectModel: PersistenceController.managedObjectModel)
    
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Failed to load container: \(error)")
      }
      else {
        print("Successfully loaded container: \(containerName)")
      }
    }
    getAllRecipes()
  }
  
  static var managedObjectModel: NSManagedObjectModel = {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: PersistenceController.self)])!
    return managedObjectModel
  }()
  
  func getAllRecipes() {
    let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    do {
      allRecipes = try container.viewContext.fetch(request)
    }
    catch let error {
      print("Error to fetch all recipes: \(error)")
    }
  }
  
  func addRecipe(_recipe: RecipeEntity) {
    getAllRecipes()
    if (allRecipes.filter({$0.name == _recipe.name}).count >= 1) {
      saveData()
    }
    else {
      let recipe = RecipeEntity(context: container.viewContext)
      recipe.name = _recipe.name
      recipe.style = _recipe.style
      recipe.og = _recipe.og
      recipe.fg = _recipe.fg
      saveData()
    }
  }
  
  func doesRecipeNameExist(name: String) -> Bool {
    if (allRecipes.filter({$0.name == name}).count >= 1) {
      return true
    }
    else {
      return false
    }
  }
  
  func deleteRecipe(index: IndexSet.Element) {
    container.viewContext.delete(allRecipes[index])
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
