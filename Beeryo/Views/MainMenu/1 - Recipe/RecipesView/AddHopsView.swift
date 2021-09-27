//
//  AddMaltsView.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//

import SwiftUI

struct AddHopsView: View {
  var unit = "kg"
  
  @State var newHopName: String = ""
  @State var newHopWeight: Int32 = 0
  @State var newHopWeight_string: String = ""
  @State var newHopDuration: Int32 = 0
  
  @State var hopName_row: String = ""
  @State var hopWeight_row: Int32 = 0
  @State var hopWeight_row_string: String = ""
  
  @ObservedObject var persistenceController = PersistenceController.shared
  
  @State var isAlertPresented = false
  @State var selectedEntity: MaltEntity? = nil
  @State var isAddRecipeSheetPresented = false
  
  var recipeEntity: RecipeEntity
  
  init(recipeEntity_: RecipeEntity) {
    self.recipeEntity = recipeEntity_
  }
  
  func convertWeight() {
    newHopWeight = Int32(newHopWeight_string) ?? 0
    hopWeight_row = Int32(hopWeight_row_string) ?? 0
  }
  
  func areInputsValid() -> Bool {
    if newHopName.isEmpty || newHopWeight <= 0 { return false }
    else { return true }
  }
  
  var body: some View {
    VStack {
      List {
        if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
          ForEach (hopEntities) { hop in
            if
              let name = hop.name,
              let weight = hop.weight,
              let duration = hop.duration {
              NavigationLink(destination: ModifyHopView(hopEntity: hop)) {
                HStack {
                  Text("\(name), ")
                  Spacer()
                  Text("\(weight) \(unit)")
                  Text("@ \(duration) min")
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
      
      VStack (alignment: .center){
        TextField_General(title: "Name:", text: "Type hop name here", bindingValue: $newHopName)
          .padding(.bottom)
        TextField_General(title: "Weight", text: "Type hop weight here", bindingValue: $newHopWeight_string)
          .padding(.bottom)
        
        Button {
          convertWeight()
          if areInputsValid() &&
              !(persistenceController.doesHopNameExist(recipe: recipeEntity, name: newHopName)) {
            persistenceController.addHopToRecipe(
              name: newHopName,
              weight: newHopWeight,
              duration: newHopDuration,
              recipeEntity: recipeEntity)
            // isAddRecipeSheetPresented = true
          }
          else { isAlertPresented = true }
        } label: {
          Text("Add new hop")
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(15.0)
        }
      }
      .padding()
      .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke())
    }
    .padding()
    .alert(isPresented: $isAlertPresented, content: {
      Alert(
        title: Text("Warning!"),
        message: Text("Hop name already exist or fields are empty!"),
        dismissButton: .cancel())
    })
    
    .navigationTitle("Add")
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ModifyHopView: View {
  var hopEntity: HopsEntity
  @ObservedObject var persistenceController = PersistenceController.shared
  @State var hopName: String
  @State var hopWeight: Int32
  @State var hopWeight_string: String = ""
  
  init(hopEntity: HopsEntity) {
    self.hopEntity = hopEntity
    _hopName = State(initialValue: hopEntity.name ?? "")
    _hopWeight = State(initialValue: hopEntity.weight)
  }
  
  func convertWeight() {
    hopWeight = Int32(hopWeight_string) ?? 0
  }
  
  func areInputsValid() -> Bool {
    if hopName.isEmpty || hopWeight <= 0 { return false }
    else { return true }
  }
  
  var body: some View {
    HStack {
      Text("Name:")
      TextField("Hop name", text: $hopName)
    }
    .padding()
    
    HStack {
      Text("Weight:")
      TextField("Hop weight", text: $hopWeight_string)
        .keyboardType(.decimalPad)
    }
    .padding()
    
    Button {
      convertWeight()
      if areInputsValid() {
        hopEntity.name = hopName
        hopEntity.weight = hopWeight
        persistenceController.saveData()
      }
      else { return }
    } label: {
      Text("Add new hop")
        .padding()
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(15.0)
    }
  }
}

struct AddHopsView_Previews: PreviewProvider {
  
  static var previews: some View {
    AddHopsView(recipeEntity_: PersistenceController.preview.allRecipes.first!)
    AddHopsView(recipeEntity_: PersistenceController.preview.allRecipes.first!)
      .preferredColorScheme(.dark)
  }
}
