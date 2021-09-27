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
                animation: .default) private var items: FetchedResults<RecipeEntity>
  
  @StateObject private var persistenceController = PersistenceController.shared
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
  
  /// <#Description#>
  var body: some View {
    VStack {
      VStack (alignment: .center){
        Section(header: SectionHeader(title: "General")){
          TextField_General(title: "Name:",
                            text: "Type name here",
                            bindingValue: $recipeName)
            .padding(.top, 5)
          TextField_General(title: "Style:",
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
          displayMaltsRow(recipeEntity: recipeEntity!)
            .padding(.bottom, 10)
          displayHopsRow(recipeEntity: recipeEntity!)
            .padding(.bottom, 10)
        }
      }
      .padding()
      .navigationTitle("Recipe Details")
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
      }.disabled(recipeName.isEmpty)
                            .alert(isPresented: $showAlert,content: {
        Alert(
          title: Text("Warning!"),
          message: Text("Recipe name already exist!"),
          dismissButton: .cancel())
      })
      )
      Spacer()
    }
  }
}

struct TextField_General: View {
  var title: String
  var text: String
  
  @Binding var bindingValue: String
  var titleTextFrameSizeH: CGFloat = 60
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
        .overlay(VStack{
          Divider()
            .background(Color("TextColor"))
          .offset(x: 0, y: 15)})
    }
  }
}

struct generalSectionRowNumeric: View {
  var title: String
  var textFieldContent: String
  
  @Binding var bindingValue: Float
  var titleTextFrameSizeH: CGFloat = 80
  var titleTextFrameSizeV: CGFloat = 20
  
  var body: some View {
    HStack{
      Text(title)
        .frame(width: titleTextFrameSizeH,
               height: titleTextFrameSizeV,
               alignment: .leading)
      TextField(textFieldContent,
                value: $bindingValue,
                formatter: NumberFormatter())
        .keyboardType(.decimalPad)
        .overlay(VStack{
          Divider()
            .background(Color.red)
          .offset(x: 0, y: 15)})
    }
  }
}

struct displayMaltsRow: View {
  let unit = "kg"
  @StateObject var recipeEntity: RecipeEntity
  
  init(recipeEntity: RecipeEntity) {
    _recipeEntity = StateObject(wrappedValue: recipeEntity)
  }
  
  var body: some View {
    HStack {
      VStack (spacing: 20){
        Text("Malts")
          .bold()
          .frame(width: 80,
                 height: 20,
                 alignment: .center)
        addOrRemoveMaltButton(recipeEntity: recipeEntity)
      }
      ScrollView(.vertical) {
        if let maltEntities = recipeEntity.malts?.allObjects as? [MaltEntity] {
          ForEach (maltEntities) { malt in
            if
              let name = malt.name,
              let weight = malt.weight {
              HStack (alignment: .center){
                Text("\(name), ")
                Spacer()
                Text(String.localizedStringWithFormat("%.2f %@", weight, unit))
              }
              .padding(.leading, 10)
              .padding(.trailing, 10)
              .padding(1)
              .cornerRadius(5)
            }
          }
        }
      }
      .padding(.top, 5)
      .padding(.bottom, 5)
      .frame(maxHeight: 120)
      .background(RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color("StrokeColor"), lineWidth: 1.0))
    }.padding(.top, 10)
  }
}

struct displayHopsRow: View {
  let unit = "g"
  @StateObject var recipeEntity: RecipeEntity
  
  init(recipeEntity: RecipeEntity) {
    _recipeEntity = StateObject(wrappedValue: recipeEntity)
  }
  
  var body: some View {
    HStack {
      VStack (spacing: 20){
        Text("Hops")
          .bold()
          .frame(width: 80,
                 height: 20,
                 alignment: .center)
        addOrRemoveHopsButton(recipeEntity: recipeEntity)
      }
      ScrollView(.vertical) {
        if let hopsEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
          ForEach (hopsEntities) { hop in
            if
              let name = hop.name,
              let weight = hop.weight,
              let duration = hop.duration {
              HStack (alignment: .center){
                Text("\(name), ")
                Spacer()
                Text("\(weight) \(unit)")
                Text("@ \(duration) min")
              }
              .padding(.leading, 10)
              .padding(.trailing, 10)
              .padding(1)
              .cornerRadius(5)
            }
          }
        }
      }
      .padding(.top, 5)
      .padding(.bottom, 5)
      .frame(maxHeight: 120)
      .background(RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color("StrokeColor"), lineWidth: 1.0))
    }.padding(.top, 10)
  }
}

struct addOrRemoveMaltButton: View {
  let imageSystemName = "plus.circle"
  @State var isAddIngredientsViewActive = false
  
  var recipeEntity: RecipeEntity
  
  init(recipeEntity: RecipeEntity) {
    self.recipeEntity = recipeEntity
  }
  
  var body: some View {
    NavigationLink(
      //destination: AddMaltsView(recipeEntity_: recipeEntity),
      destination: AddIngredientView(recipeEntity_: recipeEntity, ingredientCase: IngredientType.malt),
      isActive: $isAddIngredientsViewActive
    ) {
      Button(action: {
        isAddIngredientsViewActive = true
      }) {
        Image(systemName: imageSystemName)
          .resizable()
          .frame(width: 35, height: 35)
        
      }
    }
  }
}

struct addOrRemoveHopsButton: View {
  let imageSystemName = "plus.circle"
  @State var isAddIngredientsViewActive = false
  
  var recipeEntity: RecipeEntity
  
  init(recipeEntity: RecipeEntity) {
    self.recipeEntity = recipeEntity
  }
  
  var body: some View {
    NavigationLink(
      destination: AddIngredientView(recipeEntity_: recipeEntity, ingredientCase: IngredientType.hop),
      isActive: $isAddIngredientsViewActive
    ) {
      Button(action: {
        isAddIngredientsViewActive = true
      }) {
        Image(systemName: imageSystemName)
          .resizable()
          .frame(width: 35, height: 35)
        
      }
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
      Image(systemName: "highlighter")
        .resizable()
        .frame(width: imageSize, height: imageSize)
        .foregroundColor(Color("TextColor"))
      Text(title)
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
      RecipeEditView(recipeEntity:
                      PersistenceController.preview.allRecipes.first ??
                     RecipeEntity(context: PersistenceController.shared.container.viewContext))
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
    NavigationView {
      RecipeEditView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .preferredColorScheme(.dark)
    }
  }
}

