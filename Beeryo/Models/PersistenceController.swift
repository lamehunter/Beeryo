//
//  PersistenceController.swift
//  Beeryo
//
//  Created by Jacek K on 15/09/2021.
//

import CoreData

final class PersistenceController: ObservableObject {
  static let shared = PersistenceController()
  
  @Published var container: NSPersistentContainer
  @Published var allRecipes: [RecipeEntity] = []
  //  @Published var allMalts: [MaltEntity] = []
  //  @Published var allHops: [HopsEntity] = []
  //  @Published var allAdditions: [AdditionEntity] = []
  //  @Published var allYeasts: [YeastEntity] = []
  
  static var preview: PersistenceController = {
    let controller = PersistenceController(inMemory: true)
    for number in 0..<10 {
      let recipe = RecipeEntity(context: controller.container.viewContext)
      recipe.name = "MyBrewRecipe_\(number)"
      controller.addRecipe(_recipe: recipe)
      
      //let malt = MaltEntity(context: controller.container.viewContext)
      controller.addMaltToRecipe(name: "Pilsner_Ent\(number)", weight: "1.0", recipeEntity: recipe)
      //let hop = HopsEntity(context: controller.container.viewContext)
      controller.addHopToRecipe(name: "Lubelski_no_\(number)", weight: "12", duration: "50", recipeEntity: recipe)
      controller.addHopToRecipe(name: "Marynka_\(number)", weight: "11", duration: "70", recipeEntity: recipe)
      controller.addHopToRecipe(name: "Simcoe_\(number)", weight: "15", duration: "80", recipeEntity: recipe)
      //let yeast = YeastEntity(context: controller.container.viewContext)
      controller.addYeastToRecipe(name: "SuperLagerYeast", type: "Lager", recipeEntity: recipe)
      //let addition = AdditionEntity(context: controller.container.viewContext)
      controller.addAdditionToRecipe(name: "IrishMoss", weight: "12", duration: "5",  recipeEntity: recipe)
      controller.addMashStepToRecipe(temp: "65", duration: "60", note: "", recipeEntity: recipe)
      controller.addMashStepToRecipe(temp: "70", duration: "30", note: "", recipeEntity: recipe)
    }
    return controller
  }()
  
  init(inMemory: Bool = false) {
    
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
    // getAllMalts()
    // getAllHops()
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
  
  //  func getAllMalts() {
  //    let request = NSFetchRequest<MaltEntity>(entityName: "MaltEntity")
  //    do {
  //      allMalts = try container.viewContext.fetch(request)
  //      print("All malts no. is \(allMalts.count)")
  //    }
  //    catch let error {
  //      print("Error to fetch all malts: \(error)")
  //    }
  //  }
  //
  //  func getAllHops() {
  //    let request = NSFetchRequest<HopsEntity>(entityName: "HopsEntity")
  //    do {
  //      allHops = try container.viewContext.fetch(request)
  //    }
  //    catch let error {
  //      print("Error to fetch all Hops: \(error)")
  //    }
  //  }
  
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
  
  func addRecipeByName(_recipeName: String) {
    getAllRecipes()
    let recipe = RecipeEntity(context: container.viewContext)
    recipe.name = _recipeName
    saveData()
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
  
  func deleteHop(recipeEntity: RecipeEntity, index: IndexSet.Element) {
    if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
      container.viewContext.delete(hopEntities[index])
      saveData()
    }
  }
  
  func deleteAddition(recipeEntity: RecipeEntity, index: IndexSet.Element) {
    if let additionEntities = recipeEntity.additions?.allObjects as? [AdditionEntity] {
      container.viewContext.delete(additionEntities[index])
      saveData()
    }
  }
  
  func deleteYeast(recipeEntity: RecipeEntity, index: IndexSet.Element) {
    if let yeastEntities = recipeEntity.yeasts?.allObjects as? [YeastEntity] {
      container.viewContext.delete(yeastEntities[index])
      saveData()
    }
  }
  
  func deleteMalt(recipeEntity: RecipeEntity, index: IndexSet.Element) {
    if let maltEntities = recipeEntity.malts?.allObjects as? [MaltEntity] {
      container.viewContext.delete(maltEntities[index])
      saveData()
    }
  }
  
  func deleteMashStep(mashStepEntities: [StepMashingEntity], index: IndexSet.Element) {
      container.viewContext.delete(mashStepEntities[index])
      saveData()
      setNewIndexesAfterRemoval(mashStepEntities: mashStepEntities, afterIndex: index)
  }
  
  func setNewIndexesAfterRemoval(mashStepEntities: [StepMashingEntity], afterIndex index: IndexSet.Element) {
    for step in mashStepEntities {
      if (step.index > index) {
        step.index -= 1
      }
    }
    saveData()
  }
  
  func saveData() {
    do {
      try container.viewContext.save()
      getAllRecipes()
      //  getAllMalts()
      // getAllHops()
    }
    catch let error {
      print("Error to save recipe: \(error)")
    }
  }
  
  func addMalt(name: String, weight: Float){
    let malt = MaltEntity(context: container.viewContext)
    malt.name = name
    malt.weight = weight
    saveData()
  }
  
  func addMaltToRecipe(name: String, weight: String, recipeEntity: RecipeEntity){
    let malt = MaltEntity(context: container.viewContext)
    malt.name = name
    malt.weight = Float(weight) ?? 0.0
    malt.recipe = recipeEntity
    saveData()
  }
  
  func addHopToRecipe(name: String, weight: String, duration: String, recipeEntity: RecipeEntity) {
    let hop = HopsEntity(context: container.viewContext)
    hop.name = name
    hop.weight = Int32(weight) ?? 0
    hop.duration = Int32(duration) ?? 0
    hop.recipe = recipeEntity
    saveData()
  }
  
  func addBoilEntityToRecipe(duration: String, note: String, recipeEntity: RecipeEntity) {
    let boilEntity = BoilEntity(context: container.viewContext)
    boilEntity.note = note
    boilEntity.duration = Int16(duration) ?? 0
    boilEntity.recipe = recipeEntity
    saveData()
  }
  
  func addMashStepToRecipe(temp: String, duration: String, note: String, recipeEntity: RecipeEntity) {
    let index = recipeEntity.stepsMashing?.count ?? 0
    let mashEntity = StepMashingEntity(context: container.viewContext)
    mashEntity.note = note
    mashEntity.duration = Int16(duration) ?? 0
    mashEntity.temperature = Int16(temp) ?? 0
    mashEntity.recipe = recipeEntity
    mashEntity.index = Int16(index)
    saveData()
  }
  
  
  func addAdditionToRecipe(name: String, weight: String, duration: String, recipeEntity: RecipeEntity){
    let addition = AdditionEntity(context: container.viewContext)
    addition.name = name
    addition.weight = Int16(weight) ?? 0
    addition.duration = Int32(duration) ?? 0
    addition.recipe = recipeEntity
    saveData()
  }
  
  func addYeastToRecipe(name: String, type: String, recipeEntity: RecipeEntity){
    let yeast = YeastEntity(context: container.viewContext)
    yeast.name = name
    yeast.type = type
    yeast.recipe = recipeEntity
    saveData()
  }
  
  func doesMaltNameExist(recipe: RecipeEntity, name: String) -> Bool {
    if let recipeMalts = recipe.malts?.allObjects as? [MaltEntity] {
      if (recipeMalts.filter({$0.name == name}).count >= 1) {
        return true
      }
      else {
        return false
      }
    }
    return false
  }
  
  func doesHopNameExist(recipe: RecipeEntity, name: String) -> Bool {
    if let recipeHops = recipe.hops?.allObjects as? [HopsEntity] {
      if (recipeHops.filter({$0.name == name}).count >= 1) {
        return true
      }
      else {
        return false
      }
    }
    return false
  }
  
  func doesYeastNameExist(recipe: RecipeEntity, name: String) -> Bool {
    if let recipeYeasts = recipe.yeasts?.allObjects as? [YeastEntity] {
      if (recipeYeasts.filter({$0.name == name}).count >= 1) {
        return true
      }
      else {
        return false
      }
    }
    return false
  }
  
  func doesAdditionNameExist(recipe: RecipeEntity, name: String) -> Bool {
    if let recipeAdditions = recipe.additions?.allObjects as? [AdditionEntity] {
      if (recipeAdditions.filter({$0.name == name}).count >= 1) {
        return true
      }
      else {
        return false
      }
    }
    return false
  }
  
  func doesBoilEntityExist(recipe: RecipeEntity) -> Bool {
    if (recipe.boilDetails != nil) {
      return true
    }
    else {
      return false
    }
  }
  
  func getHopAndAdditionsQuantity(for recipe: RecipeEntity) -> Int {
    var quantity: Int = 0
    if let recipeHops = recipe.hops?.allObjects as? [HopsEntity] {
      quantity += recipeHops.count
    }
    if let recipeAdditions = recipe.additions?.allObjects as? [AdditionEntity] {
      quantity += recipeAdditions.count
    }
    return quantity
  }
}
