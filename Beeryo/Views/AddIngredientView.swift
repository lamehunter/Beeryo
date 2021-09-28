//
//  AddIngredient.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//

import SwiftUI

struct AddIngredientView: View {
  var hopUnit = "g"
  var maltUnit = "kg"
  
  //state var for hops
  @State var newHopName: String = ""
  @State var newHopWeight: Int32 = 0
  @State var newHopWeight_string: String = ""
  @State var newHopDuration: Int32 = 0
  
  //@State var hopName_row: String = ""
  //@State var hopWeight_row: Int32 = 0
  //@State var hopWeight_row_string: String = ""
  
  
  //state var for malts
  @State var newMaltName: String = ""
  @State var newMaltWeight: Float = 0.0
  @State var newMaltWeight_string: String = ""
  
  //@State var maltName_row: String = ""
  //@State var maltWeight_row: Float = 0.0
  //@State var maltWeight_row_string: String = ""
  
  @ObservedObject var persistenceController = PersistenceController.shared
  
  @State var isAlertPresented = false
  @State var isAddRecipeSheetPresented = false
  
  var recipeEntity: RecipeEntity
  var ingredient: IngredientType
  
  init(recipeEntity_: RecipeEntity, ingredient: IngredientType) {
    self.recipeEntity = recipeEntity_
    self.ingredient = ingredient
  }
  
  func convertHopWeight() {
    newHopWeight = Int32(newHopWeight_string) ?? 0
    //hopWeight_row = Int32(hopWeight_row_string) ?? 0
  }
  
  func convertMaltWeight() {
    newMaltWeight = Float(newMaltWeight_string) ?? 0.0
    //maltWeight_row = Float(maltWeight_row_string) ?? 0.0
  }
  
  var body: some View {
    VStack {
      List {
        if (ingredient == IngredientType.hop) {
          if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
            ForEach (hopEntities) { hop in
              if
                let name = hop.name,
                let weight = hop.weight,
                let duration = hop.duration {
                NavigationLink(destination: ModifyIngredientView(hopEntity: hop)) {
                  HStack {
                    Text("\(name), ")
                    Spacer()
                    Text("\(weight) \(hopUnit)")
                    Text("@ \(duration) min")
                  }
                }
              }
            }
            .onDelete(perform: { indexSet in
              indexSet.forEach { index in
                persistenceController.deleteHop(recipeEntity: recipeEntity, index: index)
              }
            })
            .listRowBackground(Color.gray.opacity(0.2))
          }
        }
        
        else if (ingredient == IngredientType.malt) {
          if let maltEntities = recipeEntity.malts?.allObjects as? [MaltEntity] {
            ForEach (maltEntities) { malt in
              if
                let name = malt.name,
                let weight = malt.weight {
                NavigationLink(destination: ModifyIngredientView(maltEntity: malt)) {
                  HStack {
                    Text("\(name)")
                      .foregroundColor(Color("TextColor"))
                    Spacer()
                    Text(String.localizedStringWithFormat("%.2f %@", weight, maltUnit))
                      .foregroundColor(Color("TextColor"))
                  }
                }
              }
            }
            .onDelete(perform: { indexSet in
              indexSet.forEach { index in
                persistenceController.deleteMalt(recipeEntity: recipeEntity, index: index)
              }
            })
            .listRowBackground(Color.gray.opacity(0.2))
          }
        }
      }
      .onAppear() {
        UITableView.appearance().backgroundColor = UIColor(Color("TextColorInversed"))
      }
      
      VStack (alignment: .center) {
        
        if (ingredient == IngredientType.hop) {
          TextField_General(title: "Name:", text: "Type hop name here", bindingValue: $newHopName)
            .padding(.bottom)
          TextField_General(title: "Weight", text: "Type hop weight here", bindingValue: $newHopWeight_string)
            .keyboardType(.decimalPad)
            .padding(.bottom)
        }
        else if (ingredient == IngredientType.malt) {
          TextField_General(title: "Name:", text: "Type malt name here", bindingValue: $newMaltName)
            .padding(.bottom)
          TextField_General(title: "Weight", text: "Type malt weight here", bindingValue: $newMaltWeight_string)
            .keyboardType(.decimalPad)
            .padding(.bottom)
        }
        
        Button {
          if (ingredient == IngredientType.hop) {
            convertHopWeight()
            if !(persistenceController.doesHopNameExist(recipe: recipeEntity, name: newHopName)) {
              persistenceController.addHopToRecipe(
                name: newHopName,
                weight: newHopWeight,
                duration: newHopDuration,
                recipeEntity: recipeEntity)
          }
            else { isAlertPresented = true }
          }
          else if (ingredient == IngredientType.malt) {
            convertMaltWeight()
            if !(persistenceController.doesMaltNameExist(recipe: recipeEntity, name: newMaltName)) {
              persistenceController.addMaltToRecipe(name: newMaltName, weight: newMaltWeight, recipeEntity: recipeEntity)
            }
            else { isAlertPresented = true }
          }
        } label: {
          Text("Add")
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
        message: Text("Ingredient name already exist or fields are empty!"),
        dismissButton: .cancel())
    })
    .navigationTitle(ingredient == IngredientType.hop ? "Add hops" : ingredient == IngredientType.malt ? "Add malts" : "error")
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ModifyIngredientView: View {
  var ingredientCase: IngredientType
  var hopEntity: HopsEntity? = nil
  var maltEntity: MaltEntity? = nil
  
  @ObservedObject var persistenceController = PersistenceController.shared
  
  //hop state variables
  @State var hopName: String = ""
  @State var hopWeight: Int32 = 0
  @State var hopWeight_string: String = ""
  
  //malt state variables
  @State var maltName: String = ""
  @State var maltWeight: Float = 0.0
  @State var maltWeight_string: String = ""
  
  init(hopEntity: HopsEntity) {
    self.hopEntity = hopEntity
    _hopName = State(initialValue: hopEntity.name ?? "")
    _hopWeight = State(initialValue: hopEntity.weight)
    ingredientCase = IngredientType.hop
  }
  
  init(maltEntity: MaltEntity) {
    self.maltEntity = maltEntity
    _maltName = State(initialValue: maltEntity.name ?? "")
    _maltWeight = State(initialValue: maltEntity.weight)
    ingredientCase = IngredientType.malt
  }
  
  func convertHopWeight() {
    hopWeight = Int32(hopWeight_string) ?? 0
  }
  
  func convertMaltWeight() {
    maltWeight = Float(maltWeight_string) ?? 0.0
  }
  
  var body: some View {
    if (ingredientCase == IngredientType.hop) {
      TextField_General(title: "Name:", text: "Type hop name here", bindingValue: $hopName)
      TextField_General(title: "Weight:", text: "Type hop weight here", bindingValue: $hopWeight_string).keyboardType(.decimalPad)
    } else if (ingredientCase == IngredientType.malt) {
      TextField_General(title: "Name:", text: "Type malt name here", bindingValue: $maltName)
      TextField_General(title: "Weight:", text: "Type malt weight here", bindingValue: $maltWeight_string).keyboardType(.decimalPad)
    }
    
    Button {
      if (ingredientCase == IngredientType.hop) {
        convertHopWeight()
        hopEntity?.name = hopName
        hopEntity?.weight = hopWeight
        persistenceController.saveData()
      }
      else if (ingredientCase == IngredientType.malt) {
        convertMaltWeight()
          maltEntity?.name = maltName
          maltEntity?.weight = maltWeight
          persistenceController.saveData()
      }
      
    } label: {
      Text("Modify")
        .padding()
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(15.0)
    }
    .disabled(ingredientCase == IngredientType.hop ? hopName.isEmpty : ingredientCase == IngredientType.malt ? maltName.isEmpty : false)
  }
}

struct AddIngredientView_Previews: PreviewProvider {
  
  static var previews: some View {
    AddIngredientView(recipeEntity_: PersistenceController.preview.allRecipes.first!, ingredient: IngredientType.hop)
    AddIngredientView(recipeEntity_: PersistenceController.preview.allRecipes.first!,
                      ingredient: IngredientType.hop)
      .preferredColorScheme(.dark)
  }
}
