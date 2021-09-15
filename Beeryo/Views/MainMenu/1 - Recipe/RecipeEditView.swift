//
//  AddRecipeView.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI

struct RecipeEditView: View {
  private var persistenceController = PersistenceController.shared
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) var presentationMode
  
  //  @FetchRequest(entity: RecipeEntity.entity(),
  //                sortDescriptors: [],
  //                animation: .default)
  //  private var items: FetchedResults<RecipeEntity>
  private var items: [RecipeEntity]
  private var recipeEntity: RecipeEntity
  
  @State var recipeName: String = ""
  @State var recipeStyle: String = ""
  @State var recipeBatchSize: String = ""
  @State var recipeOG: Float = 0.0
  @State var recipeFG: Float = 0.0
  @State var recipeMalts: String = ""
  @State var recipeHops: String = ""
  @State var recipeYeast: String = ""
  @State var showAlert: Bool = false
  @State var alertText = ""
  
  
  init(entity: RecipeEntity) {
    recipeEntity = entity
    items = persistenceController.allRecipes
    
    recipeName = entity.name ?? ""
    recipeStyle = entity.style ?? ""
    recipeOG = entity.og
    recipeFG = entity.fg
  }
  
  var body: some View {
    VStack {
      VStack (alignment: .center){
        Section(header: SectionHeader(title: "General")){
          generalSectionRow(title: "Name",
                            textFieldContent: recipeEntity.name ?? "nameNul",
                            isTextEditEnabled: true,
                            bindingValue: $recipeName)
          generalSectionRow(title: "Style",
                            textFieldContent: recipeEntity.style ?? "styleNul",
                            isTextEditEnabled: true,
                            bindingValue: $recipeStyle)
          generalSectionRow(title: "Batch size",
                            textFieldContent: "--",
                            isTextEditEnabled: true,
                            bindingValue: $recipeBatchSize)
          generalSectionRowNumeric(title: "OG",
                                   textFieldContent: recipeEntity.og == 0.0 ? "" : String(recipeEntity.og),
                            isTextEditEnabled: true,
                            bindingValue:  $recipeOG)
          generalSectionRowNumeric(title: "FG",
                            textFieldContent: recipeEntity.fg == 0.0 ? "" : String(recipeEntity.fg),
                            isTextEditEnabled: true,
                            bindingValue:  $recipeFG)
            .padding(.bottom, 20)
        }
        
        Section(header: SectionHeader(title: "Ingredients")){
          ingredientsSectionRow(title: "Malts", bindingValue: $recipeMalts)
          ingredientsSectionRow(title: "Hops", bindingValue: $recipeHops)
          ingredientsSectionRow(title: "Yeast", bindingValue: $recipeYeast)
            .padding(.bottom, 20)
        }
      }
      .padding()
      .navigationTitle("Recipe Details")
      .navigationBarItems(trailing: Button(action: {
        
        if (recipeName == ""){
          alertText = "Name field can't be empty"
          showAlert = true
        }
        else if (items.filter({$0.name == recipeName}).count >= 1){
          self.alertText = "Recipe name already exist"
          showAlert = true
        }
        else {
          recipeEntity.name = recipeName
          recipeEntity.og = recipeOG
          recipeEntity.style = recipeStyle
          recipeEntity.fg = recipeFG
          persistenceController.saveData()
          presentationMode.wrappedValue.dismiss()
        }
        
      }) {
        Text("Save")
      }
      .alert(isPresented: $showAlert, content: {
        Alert(title: Text("Text Field"), message: Text(alertText), dismissButton: .destructive(Text("Dismiss")))
      }))
      
      Spacer()
    }
  }
}

struct generalSectionRow: View {
  var title: String
  var textFieldContent: String
  var isTextEditEnabled: Bool
  @Binding var bindingValue: String
  var titleTextFrameSizeH: CGFloat = 80
  var titleTextFrameSizeV: CGFloat = 20
  
  var body: some View {
    HStack{
      Text(title)
        .frame(width: titleTextFrameSizeH,
               height: titleTextFrameSizeV,
               alignment: .leading)
      TextField(textFieldContent,
                text: $bindingValue)
        .disabled(!isTextEditEnabled)
        .overlay(VStack{
                  Divider()
                    .background(Color.red)
                    .offset(x: 0, y: 15)})
    }
  }
}

struct generalSectionRowNumeric: View {
  var title: String
  var textFieldContent: String
  var isTextEditEnabled: Bool
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
        .disabled(!isTextEditEnabled)
        .overlay(VStack{
                  Divider()
                    .background(Color.red)
                    .offset(x: 0, y: 15)})
    }
  }
}

struct ingredientsSectionRow: View {
  var title: String
  @Binding var bindingValue: String
  
  var body: some View {
    HStack {
      generalSectionRow(title: title,
                        textFieldContent: "->",
                        isTextEditEnabled: false,
                        bindingValue: $bindingValue)
      addOrRemoveButton()
    }
  }
}

struct addOrRemoveButton: View {
  let imageSystemName = "plusminus"
  @State var isAddIngredientsViewActive = false
  
  var body: some View {
    NavigationLink(
      destination: AddIngredientsView(),
      isActive: $isAddIngredientsViewActive
    ) {
      Button(action: {
        isAddIngredientsViewActive = true
      }) {
        Image(systemName: imageSystemName)
          .resizable()
          .frame(width: 15, height: 15)
      }
    }
  }
}

struct SectionHeader: View {
  let title: String
  let imageSize: CGFloat = 20
  let fontColor = Color.black
  let backgroundColor = Color.gray.opacity(0.1)
  let headerPadding: CGFloat = 5
  
  var body: some View {
    HStack  {
      Spacer()
      Image(systemName: "highlighter")
        .resizable()
        .frame(width: imageSize, height: imageSize)
      Text(title)
        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
      Spacer()
    }
    .padding(headerPadding)
    .foregroundColor(fontColor)
    .background(RoundedRectangle(cornerRadius: 10)
                  .foregroundColor(backgroundColor))
    
  }
}

struct RecipeEditView_Previews: PreviewProvider {
  static var previews: some View {
    RecipeEditView(entity: RecipeEntity())
  }
}
