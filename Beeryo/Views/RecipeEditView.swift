//
//  AddRecipeView.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI

struct RecipeEditView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) var presentationMode
  
  @FetchRequest(entity: RecipeEntity.entity(),
                sortDescriptors: [],
                animation: .default) private var recipeEntities: FetchedResults<RecipeEntity>
  
  @ObservedObject private var persistenceController = PersistenceController.shared
  
  private var recipeEntity: RecipeEntity? = nil
  
  @State var recipeName: String = ""
  @State var recipeStyle: String = ""
  @State var recipeBatchSize: String = ""
  @State var recipeOG: Float = 0.0
  @State var recipeFG: Float = 0.0
  
  @State var recipeHops: String = ""
  @State var recipeYeast: String = ""
  
  @State var showAlert: Bool = false
  
  init(recipeEntity: RecipeEntity) {
    self.recipeEntity = recipeEntity
    _recipeName = State(initialValue: recipeEntity.name ?? "")
    _recipeStyle = State(initialValue: recipeEntity.style ?? "")
  }
  
  init() {
    
  }
  
  var body: some View {
   
      ScrollView (showsIndicators: false){
        Section(header: SectionHeader(title: "General")){
          TextFieldGeneralView(title: "Name:",
                               text: "Type name here",
                               bindingValue: $recipeName)
            .padding(.top, 5)
          TextFieldGeneralView(title: "Style:",
                               text: "Type style here",
                               bindingValue: $recipeStyle)
          //          generalSectionRow(title: "Batch size",
          //                            textFieldContent: "--",
          //
          //                            bindingValue: $recipeBatchSize)
          //          generalSectionRowNumeric(title: "OG",
          //                                   textFieldContent: recipeEntity.og == 0.0 ? "" : String(recipeEntity.og),
          //
          //                                   bindingValue:  $recipeOG)
          //          generalSectionRowNumeric(title: "FG",
          //                                   textFieldContent: recipeEntity.fg == 0.0 ? "" : String(recipeEntity.fg),
          //
          //                                   bindingValue:  $recipeFG)
            .padding(.bottom, 20)
        }
        
        Section(header: SectionHeader(title: "Ingredients")){
          IngredientListView(recipeEntity: recipeEntity!, ingredient: .malt)
            .padding(.bottom, 10)
          IngredientListView(recipeEntity: recipeEntity!, ingredient: .hop)
            .padding(.bottom, 10)
          IngredientListView(recipeEntity: recipeEntity!, ingredient: .yeast)
            .padding(.bottom, 10)
          IngredientListView(recipeEntity: recipeEntity!, ingredient: .addition)
            .padding(.bottom, 10)
        }
        Section(header: SectionHeader(title: "Mashing")){
          Text("SectionInDevelopment")
        }
        Section(header: SectionHeader(title: "Boiling")){
          Text("SectionInDevelopment")
        }
        Section(header: SectionHeader(title: "Fermenting")){
          Text("SectionInDevelopment")
        }
      }
      .padding()
      .navigationBarHidden(false)
      .navigationBarTitle("Recipe Details", displayMode: .inline)
      .navigationBarItems(trailing: Button(action: {
        if (recipeEntity?.name != recipeName && persistenceController.doesRecipeNameExist(name: recipeName)) {
          showAlert = true
        }
        else {
          recipeEntity?.name = recipeName
          recipeEntity?.style = recipeStyle
          persistenceController.saveData()
          presentationMode.wrappedValue.dismiss()
        }
      }){
        Text("Save")
          .foregroundColor(Color("TextColor"))
      }.disabled(recipeName.isEmpty)
                            .alert(isPresented: $showAlert,content: {
        Alert(
          title: Text("Warning!"),
          message: Text("Recipe name already exist!"),
          dismissButton: .cancel())
      }))
      
  }
}

struct TextFieldGeneralView: View {
  var title: String
  var text: String
  
  @Binding var bindingValue: String
  var titleTextFrameSizeH: CGFloat = 75
  var titleTextFrameSizeV: CGFloat = 20
  
  var body: some View {
    HStack{
      Text(title)
        .bold()
        .frame(width: titleTextFrameSizeH,
               height: titleTextFrameSizeV,
               alignment: .leading)
      TextField(text,
                text: $bindingValue)
        .overlay(VStack {
          Divider()
            .background(Color("TextColor"))
          .offset(x: 0, y: 15)})
    }
  }
}

struct IngredientListView: View {
  let maltUnit = "kg"
  let hopUnit = "g"
  let additionUnit = "g"
  var ingredient: IngredientType
  
  @StateObject var recipeEntity: RecipeEntity
  @ObservedObject var persistenceController = PersistenceController.shared
  
  init(recipeEntity: RecipeEntity, ingredient: IngredientType) {
    _recipeEntity = StateObject(wrappedValue: recipeEntity)
    self.ingredient = ingredient
  }
  
  var body: some View {
    HStack {
      VStack (spacing: 10){
        Text(ingredient == IngredientType.malt ? "Malts" :
              ingredient == IngredientType.hop ? "Hops" :
              ingredient == IngredientType.yeast ? "Yeasts" :
              ingredient == IngredientType.addition ? "Additions" : "error")
          .bold()
          .frame(width: 80,
                 height: 20,
                 alignment: .center)
        AddIngredientButton(recipeEntity: recipeEntity, ingredient: ingredient)
      }
      ScrollView(.vertical) {
        switch ingredient {
        case IngredientType.malt:
          if let maltEntities = recipeEntity.malts?.allObjects as? [MaltEntity] {
            ForEach (maltEntities) { malt in
              if
                let name = malt.name,
                let weight = malt.weight {
                HStack (alignment: .center){
                  Text("\(name), ")
                    .font(.footnote)
                  Spacer()
                  Text(String.localizedStringWithFormat("%.2f %@", weight, maltUnit))
                    .font(.footnote)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(1)
                .cornerRadius(5)
              }
            }
          }
          
        case IngredientType.hop:
          if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
            ForEach (hopEntities) { hop in
              if
                let name = hop.name,
                let weight = hop.weight,
                let duration = hop.duration {
                HStack {
                  Text("\(name), ")
                    .font(.footnote)
                  Spacer()
                  Text("\(weight)\(hopUnit)")
                    .font(.footnote)
                  Text("\\")
                    .font(.footnote)
                  Text("\(duration)min")
                    .font(.footnote)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(1)
                .cornerRadius(5)
              }
            }
          }
        case IngredientType.yeast:
          if let yeastEntities = recipeEntity.yeasts?.allObjects as? [YeastEntity] {
            ForEach (yeastEntities) { yeast in
              if
                let name = yeast.name,
                let type = yeast.type {
                HStack {
                  Text("\(name), ")
                    .font(.footnote)
                  Spacer()
                  Text("\(type)")
                    .font(.footnote)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(1)
                .cornerRadius(5)
              }
            }
          }
          
        case IngredientType.addition:
          if let additionEntities = recipeEntity.additions?.allObjects as? [AdditionEntity] {
            ForEach (additionEntities) { addition in
              if
                let name = addition.name,
                let weight = addition.weight {
                HStack {
                  Text("\(name), ")
                    .font(.footnote)
                  Spacer()
                  Text("\(weight)\(additionUnit)")
                    .font(.footnote)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(1)
                .cornerRadius(5)
              }
            }
          }
        }
      }
      .frame(minHeight: 60)
      .padding(.top, 5)
      .padding(.bottom, 5)
      .background(
        RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color("StrokeColor"), lineWidth: 1.0)
      )
    }
    .padding(.top, 10)
  }
}

struct AddIngredientButton: View {
  let imageSystemName = "plusminus.circle"
  @State var isAddIngredientsViewActive = false
  
  var recipeEntity: RecipeEntity
  var ingredient: IngredientType
  
  init(recipeEntity: RecipeEntity, ingredient: IngredientType) {
    self.recipeEntity = recipeEntity
    self.ingredient = ingredient
  }
  
  var body: some View {
    NavigationLink(
      destination: AddIngredientView(recipeEntity_: recipeEntity, ingredient: ingredient),
      isActive: $isAddIngredientsViewActive
    ) {
      Button(action: {
        isAddIngredientsViewActive = true
      }) {
        Image(systemName: imageSystemName)
          .resizable()
          .frame(width: 35, height: 35)
      }
      .foregroundColor(Color("TextColor"))
    }
  }
}

struct SectionHeader: View {
  let title: String
  let imageSize: CGFloat = 20
  let fontColor = Color.black
  let backgroundColor = Color("BackgroundRectangleColor")
  let headerPadding: CGFloat = 5
  
  var body: some View {
    HStack  {
      Spacer()
      //      Image(systemName: "highlighter")
      //        .resizable()
      //        .frame(width: imageSize, height: imageSize)
      //        .foregroundColor(Color("TextColor"))
      Text(title)
        .font(.body)
        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        .foregroundColor(Color("TextColor"))
      Spacer()
    }
    .padding(headerPadding)
    .foregroundColor(fontColor)
    .background(RoundedRectangle(cornerRadius: 10)
                  .strokeBorder(Color("StrokeColor"), lineWidth: 1.0))
  }
}

struct RecipeEditView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RecipeEditView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
    NavigationView {
      RecipeEditView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .preferredColorScheme(.dark)
    }
  }
}

