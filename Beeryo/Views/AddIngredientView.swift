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
  var additionUnit = "g"
  
  @Environment(\.presentationMode) var presentationMode
  
  //state var for hops
  @State var newHopName: String = ""
  @State var newHopWeight: Int32 = 0
  @State var newHopWeight_string: String = ""
  @State var newHopDuration: Int32 = 0
  
  //state var for malts
  @State var newMaltName: String = ""
  @State var newMaltWeight: Float = 0.0
  @State var newMaltWeight_string: String = ""
  
  //state var for yeasts
  @State var newYeastName: String = ""
  @State var newYeastType: String = ""
  
  //state var for additions
  @State var newAdditionName: String = ""
  @State var newAdditionWeight: Int16 = 0
  @State var newAdditionWeight_string: String = ""
  
  @ObservedObject var persistenceController = PersistenceController.shared
  
  @State var isAlertPresented = false
  @State var showAddNewIngredientView = false
  
  var recipeEntity: RecipeEntity
  var ingredient: IngredientType
  
  init(recipeEntity_: RecipeEntity, ingredient: IngredientType) {
    self.recipeEntity = recipeEntity_
    self.ingredient = ingredient
  }
  
  func convertHopWeight() {
    newHopWeight = Int32(newHopWeight_string) ?? 0
  }
  
  func convertMaltWeight() {
    newMaltWeight = Float(newMaltWeight_string) ?? 0.0
  }
  
  func convertAdditionWeight() {
    newAdditionWeight = Int16(newAdditionWeight_string) ?? 0
  }
  
  var body: some View {
    ZStack {
      List {
        switch ingredient {
        case .hop:
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
                    Text("\(weight)\(hopUnit)")
                    Text("/ \(duration)min")
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
          
        case .malt:
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
          
        case .yeast:
          if let yeastEntities = recipeEntity.yeasts?.allObjects as? [YeastEntity] {
            ForEach (yeastEntities) { yeast in
              if
                let name = yeast.name,
                let type = yeast.type {
                NavigationLink(destination: ModifyIngredientView(yeastEntity: yeast)) {
                  HStack {
                    Text("\(name)")
                      .foregroundColor(Color("TextColor"))
                    Spacer()
                    Text("\(type)")
                      .foregroundColor(Color("TextColor"))
                  }
                }
              }
            }
            .onDelete(perform: { indexSet in
              indexSet.forEach { index in
                persistenceController.deleteYeast(recipeEntity: recipeEntity, index: index)
              }
            })
            .listRowBackground(Color.gray.opacity(0.2))
          }
        case .addition:
          if let additionEntities = recipeEntity.additions?.allObjects as? [AdditionEntity] {
            ForEach (additionEntities) { addition in
              if
                let name = addition.name,
                let weight = addition.weight {
                
                NavigationLink(destination: ModifyIngredientView(additionEntity: addition)) {
                  HStack {
                    Text("\(name)")
                      .foregroundColor(Color("TextColor"))
                    Spacer()
                    Text("\(weight)\(additionUnit)")
                      .foregroundColor(Color("TextColor"))
                  }
                }
              }
            }
            .onDelete(perform: { indexSet in
              indexSet.forEach { index in
                persistenceController.deleteAddition(recipeEntity: recipeEntity, index: index)
              }
            })
            .listRowBackground(Color.gray.opacity(0.2))
          }
        }
      }
      .listStyle(.plain)
      .navigationBarItems(trailing:
                            Image(systemName: "plus")
                            .onTapGesture(perform: {
        showAddNewIngredientView = true
      })
      )
      
      ZStack (alignment: .topLeading) {
        Color(.white)
        Button (action: {
          showAddNewIngredientView.toggle()
        }, label: {
          Image(systemName: "xmark")
            .foregroundColor(.black)
            .font(.largeTitle)
            .padding()
        })
        VStack (alignment: .center) {
          switch ingredient {
          case .hop:
            TextFieldGeneralView(title: "Name:", text: "Type hop name here", bindingValue: $newHopName)
              .padding(.bottom)
            TextFieldGeneralView(title: "Weight:", text: "Type hop weight here", bindingValue: $newHopWeight_string)
              .keyboardType(.decimalPad)
              .padding(.bottom)
            
          case .malt:
            TextFieldGeneralView(title: "Name:", text: "Type malt name here", bindingValue: $newMaltName)
              .padding(.bottom)
            TextFieldGeneralView(title: "Weight", text: "Type malt weight here", bindingValue: $newMaltWeight_string)
              .keyboardType(.decimalPad)
              .padding(.bottom)
            
          case .yeast:
            TextFieldGeneralView(title: "Name:", text: "Type yeast name here", bindingValue: $newYeastName)
              .padding(.bottom)
            TextFieldGeneralView(title: "Type:", text: "Type yeast type here", bindingValue: $newYeastType)
              .padding(.bottom)
            
          case .addition:
            TextFieldGeneralView(title: "Name:", text: "Type addition name here", bindingValue: $newAdditionName)
              .padding(.bottom)
            TextFieldGeneralView(title: "Weight", text: "Type addition weight here", bindingValue: $newAdditionWeight_string)
              .keyboardType(.decimalPad)
              .padding(.bottom)
          }
          
          Button {
            switch ingredient {
              
            case .hop:
              convertHopWeight()
              if !(persistenceController.doesHopNameExist(recipe: recipeEntity, name: newHopName)) {
                persistenceController.addHopToRecipe(
                  name: newHopName,
                  weight: newHopWeight,
                  duration: newHopDuration,
                  recipeEntity: recipeEntity)
              }
              else { isAlertPresented = true }
              
            case .malt:
              convertMaltWeight()
              if !(persistenceController.doesMaltNameExist(recipe: recipeEntity, name: newMaltName)) {
                persistenceController.addMaltToRecipe(name: newMaltName, weight: newMaltWeight, recipeEntity: recipeEntity)
              }
              else { isAlertPresented = true }
              
            case .yeast:
              if !(persistenceController.doesYeastNameExist(recipe: recipeEntity, name: newYeastName)) {
                persistenceController.addYeastToRecipe(name: newYeastName, type: newYeastType, recipeEntity: recipeEntity)
              }
              else { isAlertPresented = true }
              
            case .addition:
              convertAdditionWeight()
              if !(persistenceController.doesAdditionNameExist(recipe: recipeEntity, name: newAdditionName)) {
                persistenceController.addAdditionToRecipe(name: newAdditionName, weight: newAdditionWeight, recipeEntity: recipeEntity)
              }
              else { isAlertPresented = true }
              
            }
            newHopName = ""
            newHopWeight_string = ""
            newHopWeight = 0
            
            newMaltName = ""
            newMaltWeight = 0
            newMaltWeight_string = ""
            
            newYeastName = ""
            newYeastType = ""
            
            newAdditionName = ""
            newAdditionWeight = 0
            newAdditionWeight_string = ""
            
            showAddNewIngredientView.toggle()
          } label: {
            Text("Add")
              .frame(maxWidth: .infinity)
              .padding(10)
              .foregroundColor(Color("TextColorInversed"))
              .background(Color("TextColor"))
              .cornerRadius(15.0)
          }
        }
        .padding()
        .padding(.top, 50)
        .onAppear() {
          UITableView.appearance().backgroundColor = UIColor(Color("TextColorInversed"))
        }
      }
      .offset(y: showAddNewIngredientView ? 0 : UIScreen.main.bounds.height)
      .zIndex(2.0)
      .animation(.spring())
    }
    .alert(isPresented: $isAlertPresented, content: {
      Alert(
        title: Text("Warning!"),
        message: Text("Ingredient name already exist or fields are empty!"),
        dismissButton: .cancel())
    })
    .navigationBarTitle(
      ingredient == IngredientType.hop ? "Add hops" :
        ingredient == IngredientType.malt ? "Add malts" :
        ingredient == IngredientType.yeast ? "Add yeasts" :
        ingredient == IngredientType.addition ? "Add additions" :
        "error", displayMode: .inline)
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ModifyIngredientView: View {
  var ingredient: IngredientType
  var hopEntity: HopsEntity? = nil
  var maltEntity: MaltEntity? = nil
  var yeastEntity: YeastEntity? = nil
  var additionEntity: AdditionEntity? = nil
  
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var persistenceController = PersistenceController.shared
  
  //hop state variables
  @State var hopName: String = ""
  @State var hopWeight: Int32 = 0
  @State var hopWeight_string: String = ""
  
  //malt state variables
  @State var maltName: String = ""
  @State var maltWeight: Float = 0.0
  @State var maltWeight_string: String = ""
  
  //yeast state variables
  @State var yeastName: String = ""
  @State var yeastType: String = ""
  
  //addition state variables
  @State var additionName: String = ""
  @State var additionWeight: Int16 = 0
  @State var additionWeight_string: String = ""
  
  init(hopEntity: HopsEntity) {
    self.hopEntity = hopEntity
    _hopName = State(initialValue: hopEntity.name ?? "")
    _hopWeight = State(initialValue: hopEntity.weight)
    _hopWeight_string = State(initialValue: String(hopEntity.weight))
    ingredient = .hop
  }
  
  init(maltEntity: MaltEntity) {
    self.maltEntity = maltEntity
    _maltName = State(initialValue: maltEntity.name ?? "")
    _maltWeight = State(initialValue: maltEntity.weight)
    _maltWeight_string = State(initialValue: String(maltEntity.weight))
    ingredient = .malt
  }
  
  init(yeastEntity: YeastEntity) {
    self.yeastEntity = yeastEntity
    _yeastName = State(initialValue: yeastEntity.name ?? "")
    _yeastType = State(initialValue: yeastEntity.type ?? "")
    ingredient = .yeast
  }
  
  init(additionEntity: AdditionEntity) {
    self.additionEntity = additionEntity
    _additionName = State(initialValue: additionEntity.name ?? "")
    _additionWeight = State(initialValue: additionEntity.weight)
    _additionWeight_string = State(initialValue: String(additionEntity.weight))
    ingredient = .addition
  }
  
  func convertHopWeight() {
    hopWeight = Int32(hopWeight_string) ?? 0
  }
  
  func convertMaltWeight() {
    maltWeight = Float(maltWeight_string) ?? 0.0
  }
  
  func convertAdditionWeight() {
    additionWeight = Int16(additionWeight_string) ?? 0
  }
  
  var body: some View {
    VStack {
      switch ingredient {
      case .hop:
        TextFieldGeneralView(title: "Name:", text: "Type hop name here", bindingValue: $hopName)
        TextFieldGeneralView(title: "Weight:", text: "Type hop weight here", bindingValue: $hopWeight_string).keyboardType(.decimalPad)
        
      case .malt:
        TextFieldGeneralView(title: "Name:", text: "Type malt name here", bindingValue: $maltName)
        TextFieldGeneralView(title: "Weight:", text: "Type malt weight here", bindingValue: $maltWeight_string).keyboardType(.decimalPad)
        
      case .yeast:
        TextFieldGeneralView(title: "Name:", text: "Type yest name here", bindingValue: $yeastName)
        TextFieldGeneralView(title: "Type:", text: "Type yeast type here", bindingValue: $yeastType)
        
      case .addition:
        TextFieldGeneralView(title: "Name:", text: "Type addition here", bindingValue: $additionName)
        TextFieldGeneralView(title: "Weight:", text: "Type addition weight here", bindingValue: $additionWeight_string).keyboardType(.decimalPad)
      }
      Button {
        switch ingredient {
        case .hop:
          convertHopWeight()
          hopEntity?.name = hopName
          hopEntity?.weight = hopWeight
          persistenceController.saveData()
          presentationMode.wrappedValue.dismiss()
        case .malt:
          convertMaltWeight()
          maltEntity?.name = maltName
          maltEntity?.weight = maltWeight
          persistenceController.saveData()
          presentationMode.wrappedValue.dismiss()
          
        case .yeast:
          yeastEntity?.name = yeastName
          yeastEntity?.type = yeastType
          persistenceController.saveData()
          presentationMode.wrappedValue.dismiss()
          
        case .addition:
          convertAdditionWeight()
          additionEntity?.name = additionName
          additionEntity?.weight = additionWeight
          persistenceController.saveData()
          presentationMode.wrappedValue.dismiss()
        }
      } label: {
        Text("Modify")
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(15.0)
      }
      .disabled(ingredient == .hop ? hopName.isEmpty :
                ingredient == .malt ? maltName.isEmpty :
                ingredient == .yeast ? yeastName.isEmpty :
                ingredient == .addition ? additionName.isEmpty :
                false)
    }
  }
}

struct AddIngredientView_Previews: PreviewProvider {
  
  static var previews: some View {
    AddIngredientView(recipeEntity_: PersistenceController.preview.allRecipes.first!, ingredient: IngredientType.hop)
    AddIngredientView(recipeEntity_: PersistenceController.preview.allRecipes.first!,
                      ingredient: IngredientType.hop)
      .preferredColorScheme(.dark)
    
    ModifyIngredientView(maltEntity: (PersistenceController.preview.allRecipes.first?.malts?.allObjects as? [MaltEntity])!.first!)
  }
}
