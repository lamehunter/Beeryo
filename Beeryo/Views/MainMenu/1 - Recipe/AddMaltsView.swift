//
//  AddMaltsView.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//

import SwiftUI

struct AddMaltsView: View {
  var unit = "kg"
  
  @State var maltName: String = ""
  @State var maltWeight: Float = 0.0
  @State var maltWeightString: String = ""
  @ObservedObject var persistenceController = PersistenceController.shared
  @State var isAlertPresented = false
  
  var recipeEntity: RecipeEntity
  
  init(recipeEntity_: RecipeEntity) {
    self.recipeEntity = recipeEntity_
  }
  
  func convertWeight(){
    maltWeight = Float(maltWeightString) ?? 0.0
  }
  
  func areInputsValid() -> Bool {
    if maltName.isEmpty || maltWeight <= 0.0 { return false }
    else { return true }
  }
  
  var body: some View {
    VStack {
      List {
        if let maltEntities = recipeEntity.malts?.allObjects as? [MaltEntity] {
          ForEach (maltEntities) { malt in
            if
              let name = malt.name,
              let weight = malt.weight {
              HStack{
                Text("\(name)")
                Spacer()
                Text(String.localizedStringWithFormat("%.2f %@", weight, unit))
              }
            }
          }.listRowBackground(Color.yellow)
        }
      }.background(Color.red)
      HStack {
        Text("Name:")
        TextField("Malt name", text: $maltName)
      }
      .padding()
      
      HStack {
        Text("Weight:")
        TextField("Malt weight", text: $maltWeightString).keyboardType(.decimalPad)
      }
      .padding()
      
      Button {
        convertWeight()
        if areInputsValid() &&
            !(persistenceController.doesMaltNameExist(recipe: recipeEntity, name: maltName)) {
          persistenceController.addMaltToRecipe(name: maltName, weight: maltWeight, recipeEntity: recipeEntity)
        }
        else { isAlertPresented = true }
      } label: {
        Text("Add new malt")
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(15.0)
      }
    }
    .padding()
    .alert(isPresented: $isAlertPresented, content: {
      Alert(
        title: Text("Warning!"),
        message: Text("Malt name already exist!"),
        dismissButton: .cancel())
    })
    .navigationTitle("Add malts")
  }
}

struct AddMaltsView_Previews: PreviewProvider {
  
  static var previews: some View {
    AddMaltsView(recipeEntity_: PersistenceController.preview.allRecipes.first!)
  }
}
