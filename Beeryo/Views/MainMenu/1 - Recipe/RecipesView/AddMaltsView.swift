//
//  AddMaltsView.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//

import SwiftUI

struct AddMaltsView: View {
  var unit = "kg"
  
  @State var newMaltName: String = ""
  @State var newMaltWeight: Float = 0.0
  @State var newMaltWeight_string: String = ""
  
  @State var maltName_row: String = ""
  @State var maltWeight_row: Float = 0.0
  @State var maltWeight_row_string: String = ""
  
  @ObservedObject var persistenceController = PersistenceController.shared
  
  @State var isAlertPresented = false
  @State var selectedEntity: MaltEntity? = nil
  @State var isAddRecipeSheetPresented = false
  
  var recipeEntity: RecipeEntity
  
  init(recipeEntity_: RecipeEntity) {
    self.recipeEntity = recipeEntity_
  }
  
  func convertWeight() {
    newMaltWeight = Float(newMaltWeight_string) ?? 0.0
    maltWeight_row = Float(maltWeight_row_string) ?? 0.0
  }
  
  func areInputsValid() -> Bool {
    if newMaltName.isEmpty || newMaltWeight <= 0.0 { return false }
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
              NavigationLink(destination: ModifyMaltView(maltEntity: malt)) {
                HStack {
                  Text("\(name)")
                    .foregroundColor(Color("TextColor"))
                  Spacer()
                  Text(String.localizedStringWithFormat("%.2f %@", weight, unit))
                    .foregroundColor(Color("TextColor"))
                }
              }
            }
          }
          .listRowBackground(Color.gray.opacity(0.2))
        }
      }
      .onAppear() {
        UITableView.appearance().backgroundColor = UIColor(Color("TextColorInversed"))
      }
      
      HStack {
        Text("Name:")
        TextField("Malt name", text: $newMaltName)
      }
      .padding(.leading)
      .padding(.trailing)
      
      HStack {
        Text("Weight:")
        TextField("Malt weight", text: $newMaltWeight_string).keyboardType(.decimalPad)
      }
      .padding()
      
      Button {
        convertWeight()
        if areInputsValid() &&
            !(persistenceController.doesMaltNameExist(recipe: recipeEntity, name: newMaltName)) {
          persistenceController.addMaltToRecipe(name: newMaltName, weight: newMaltWeight, recipeEntity: recipeEntity)
          // isAddRecipeSheetPresented = true
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
        message: Text("Malt name already exist or fields are empty!"),
        dismissButton: .cancel())
    })
    
    .navigationTitle("Add malts")
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ModifyMaltView: View {
  var maltEntity: MaltEntity
  @ObservedObject var persistenceController = PersistenceController.shared
  @State var maltName: String
  @State var maltWeight: Float
  @State var maltWeight_string: String = ""
  
  init(maltEntity: MaltEntity) {
    self.maltEntity = maltEntity
    _maltName = State(initialValue: maltEntity.name ?? "")
    _maltWeight = State(initialValue: maltEntity.weight)
  }
  
  func convertWeight() {
    maltWeight = Float(maltWeight_string) ?? 0.0
  }
  
  func areInputsValid() -> Bool {
    if maltName.isEmpty || maltWeight <= 0.0 { return false }
    else { return true }
  }
  
  var body: some View {
    HStack {
      Text("Name:")
      TextField("Malt name", text: $maltName)
    }
    .padding()
    
    HStack {
      Text("Weight:")
      TextField("Malt weight", text: $maltWeight_string)
        .keyboardType(.decimalPad)
    }
    .padding()
    
    Button {
      convertWeight()
      if areInputsValid() {
        maltEntity.name = maltName
        maltEntity.weight = maltWeight
        persistenceController.saveData()
      }
      else { return }
    } label: {
      Text("Add new malt")
        .padding()
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(15.0)
    }
  }
}

struct AddMaltsView_Previews: PreviewProvider {
  
  static var previews: some View {
    AddMaltsView(recipeEntity_: PersistenceController.preview.allRecipes.first!)
    AddMaltsView(recipeEntity_: PersistenceController.preview.allRecipes.first!)
      .preferredColorScheme(.dark)
  }
}
