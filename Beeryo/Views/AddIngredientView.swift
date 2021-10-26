//
//  AddIngredient.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//

import SwiftUI

//closing keyboard
extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct AddIngredientView: View {
  var hopUnit = "g"
  var maltUnit = "kg"
  var additionUnit = "g"
  var timeUnit = "min"
  
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.colorScheme) var colorScheme
  
  //state var for hops
  @State var newHopName: String = ""
  @State var newHopWeight: String = ""
  @State var newHopDuration: String = ""
  
  //state var for malts
  @State var newMaltName: String = ""
  @State var newMaltWeight: String = ""
  
  //state var for yeasts
  @State var newYeastName: String = ""
  @State var newYeastType: String = ""
  
  //state var for additions
  @State var newAdditionName: String = ""
  @State var newAdditionWeight: String = ""
  @State var newAdditionDuration: String = ""
  
  @ObservedObject var persistenceController = PersistenceController.shared
  
  @State var isAlertPresented = false
  @State var showAddNewIngredientView = false
  
  var recipeEntity: RecipeEntity
  var ingredient: IngredientType
  
  init(recipeEntity_: RecipeEntity, ingredient: IngredientType) {
    self.recipeEntity = recipeEntity_
    self.ingredient = ingredient
  }
  
  func resetFieldsAndDissmissView() {
    showAddNewIngredientView.toggle()
    newHopName = ""
    newHopWeight = ""
    newMaltName = ""
    newMaltWeight = ""
    newYeastName = ""
    newYeastType = ""
    newAdditionName = ""
    newAdditionWeight = ""
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
                    Text("/ \(duration)\(timeUnit)")
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
        Color("TextColorInversed")
        Button (action: {
          showAddNewIngredientView.toggle()
        }, label: {
          Image(systemName: "xmark")
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .font(.largeTitle)
            .padding()
        })
        VStack (alignment: .center) {
          switch ingredient {
          case .hop:
            TextFieldGeneralView(title: "Name:", text: "Type hop name here", bindingValue: $newHopName)
              .padding(.bottom)
            TextFieldGeneralView(title: "Weight:", text: "Type hop weight here", bindingValue: $newHopWeight)
              .keyboardType(.decimalPad)
              .padding(.bottom)
            TextFieldGeneralView(title: "Duration:", text: "Type duration", bindingValue: $newHopDuration)
              .keyboardType(.decimalPad)
              .padding(.bottom)
            
          case .malt:
            TextFieldGeneralView(title: "Name:", text: "Type malt name here", bindingValue: $newMaltName)
              .padding(.bottom)
            TextFieldGeneralView(title: "Weight", text: "Type malt weight here", bindingValue: $newMaltWeight)
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
            TextFieldGeneralView(title: "Weight", text: "Type addition weight here", bindingValue: $newAdditionWeight)
              .keyboardType(.decimalPad)
              .padding(.bottom)
            TextFieldGeneralView(title: "Duration", text: "Type addition duration here", bindingValue: $newAdditionDuration)
              .keyboardType(.decimalPad)
              .padding(.bottom)
          }
          
          Button {
            hideKeyboard()
            switch ingredient {
            case .hop:
              if (newHopName.isEmpty ||
                  persistenceController.doesHopNameExist(recipe: recipeEntity, name: newHopName)) {
                isAlertPresented = true
              }
              else {
                persistenceController.addHopToRecipe(
                  name: newHopName,
                  weight: newHopWeight,
                  duration: newHopDuration,
                  recipeEntity: recipeEntity)
                resetFieldsAndDissmissView()
              }
            case .malt:
              if (newMaltName.isEmpty ||
                  persistenceController.doesMaltNameExist(recipe: recipeEntity,
                                                          name: newMaltName) ) {
                isAlertPresented = true
              }
              else {
                persistenceController.addMaltToRecipe(name: newMaltName,
                                                      weight: newMaltWeight,
                                                      recipeEntity: recipeEntity)
                resetFieldsAndDissmissView()
              }
            case .yeast:
              if (newYeastName.isEmpty ||
                  persistenceController.doesYeastNameExist(recipe: recipeEntity,
                                                           name: newYeastName)) {
                isAlertPresented = true
              }
              else {
                persistenceController.addYeastToRecipe(name: newYeastName,
                                                       type: newYeastType,
                                                       recipeEntity: recipeEntity)
                resetFieldsAndDissmissView()
              }
            case .addition:
              if (newAdditionName.isEmpty ||
                  persistenceController.doesAdditionNameExist(recipe: recipeEntity,
                                                              name: newAdditionName)) {
                isAlertPresented = true
              }
              else {
                persistenceController.addAdditionToRecipe(name: newAdditionName,
                                                          weight: newAdditionWeight,
                                                          duration: newAdditionDuration,
                                                          recipeEntity: recipeEntity)
                resetFieldsAndDissmissView()
              }
            }
            
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
        title: Text("Warning"),
        message: Text("Ingredient name is empty, or name already exist!"),
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
  
  @State var isValidationAlertPresented = false
  
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var persistenceController = PersistenceController.shared
  
  //hop state variables
  @State var hopName: String = ""
  @State var hopWeight: String = ""
  @State var hopDuration: String = ""
  
  //malt state variables
  @State var maltName: String = ""
  @State var maltWeight: String = ""
  
  //yeast state variables
  @State var yeastName: String = ""
  @State var yeastType: String = ""
  
  //addition state variables
  @State var additionName: String = ""
  @State var additionWeight: String = ""
  @State var additionDuration: String = ""
  
  init(hopEntity: HopsEntity) {
    self.hopEntity = hopEntity
    _hopName = State(initialValue: hopEntity.name ?? "")
    _hopWeight = State(initialValue: String(hopEntity.weight))
    _hopDuration = State(initialValue: String(hopEntity.duration))
    ingredient = .hop
  }
  
  init(maltEntity: MaltEntity) {
    self.maltEntity = maltEntity
    _maltName = State(initialValue: maltEntity.name ?? "")
    _maltWeight = State(initialValue: String(maltEntity.weight))
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
    _additionWeight = State(initialValue: String(additionEntity.weight))
    _additionDuration = State(initialValue: String(additionEntity.duration))
    ingredient = .addition
  }
  
  var body: some View {
    VStack {
      switch ingredient {
      case .hop:
        TextFieldGeneralView(title: "Name:", text: "Type hop name here", bindingValue: $hopName)
        TextFieldGeneralView(title: "Weight:", text: "Type hop weight here", bindingValue: $hopWeight).keyboardType(.decimalPad)
        TextFieldGeneralView(title: "Duration:", text: "Type duration", bindingValue: $hopDuration)
          .keyboardType(.decimalPad)
        
      case .malt:
        TextFieldGeneralView(title: "Name:", text: "Type malt name here", bindingValue: $maltName)
        TextFieldGeneralView(title: "Weight:", text: "Type malt weight here", bindingValue: $maltWeight).keyboardType(.decimalPad)
        
      case .yeast:
        TextFieldGeneralView(title: "Name:", text: "Type yest name here", bindingValue: $yeastName)
        TextFieldGeneralView(title: "Type:", text: "Type yeast type here", bindingValue: $yeastType)
        
      case .addition:
        TextFieldGeneralView(title: "Name:", text: "Type addition here", bindingValue: $additionName)
        TextFieldGeneralView(title: "Weight:", text: "Type addition weight here", bindingValue: $additionWeight).keyboardType(.decimalPad)
        TextFieldGeneralView(title: "Duration:", text: "Type addition duration here", bindingValue: $additionDuration).keyboardType(.decimalPad)
      }
      
      Button {
        switch ingredient {
        case .hop:
          if (hopName.isEmpty || hopWeight.isEmpty || hopDuration.isEmpty) {
            isValidationAlertPresented = true
            break
          }
          hopEntity?.name = hopName
          hopEntity?.weight = Int32(hopWeight) ?? 0
          hopEntity?.duration = Int32(hopDuration) ?? 0
          persistenceController.saveData()
          hideKeyboard()
          presentationMode.wrappedValue.dismiss()
        case .malt:
          if (maltName.isEmpty || maltWeight.isEmpty) {
            isValidationAlertPresented = true
            break
          }
          maltEntity?.name = maltName
          maltEntity?.weight = Float(maltWeight) ?? 0.0
          persistenceController.saveData()
          hideKeyboard()
          presentationMode.wrappedValue.dismiss()
        case .yeast:
          if (yeastName.isEmpty || yeastType.isEmpty) {
            isValidationAlertPresented = true
            break
          }
          yeastEntity?.name = yeastName
          yeastEntity?.type = yeastType
          persistenceController.saveData()
          hideKeyboard()
          presentationMode.wrappedValue.dismiss()
        case .addition:
          if (additionName.isEmpty || additionWeight.isEmpty || additionDuration.isEmpty) {
            isValidationAlertPresented = true
            break
          }
          additionEntity?.name = additionName
          additionEntity?.weight = Int16(additionWeight) ?? 0
          additionEntity?.duration = Int32(additionDuration) ?? 0
          persistenceController.saveData()
          hideKeyboard()
          presentationMode.wrappedValue.dismiss()
        }
      } label: {
        Text("Modify")
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(15.0)
      }
      .alert(isPresented: $isValidationAlertPresented) {
        Alert(title: Text("Warning"), message: Text("Fields can't be empty"), dismissButton: .destructive(Text("ok")))
      }
    }
    .padding()
  }
}

struct AddIngredientView_Previews: PreviewProvider {
  
  static var previews: some View {
    AddIngredientView(recipeEntity_: PersistenceController.preview.allRecipes.first!, ingredient: IngredientType.hop)
    AddIngredientView(recipeEntity_: PersistenceController.preview.allRecipes.first!,
                      ingredient: IngredientType.hop)
      .preferredColorScheme(.dark)
    
    ModifyIngredientView(hopEntity: (PersistenceController.preview.allRecipes.first?.hops?.allObjects as? [HopsEntity])!.first!)
    ModifyIngredientView(hopEntity: (PersistenceController.preview.allRecipes.first?.hops?.allObjects as? [HopsEntity])!.first!)
      .preferredColorScheme(.dark)
  }
}
