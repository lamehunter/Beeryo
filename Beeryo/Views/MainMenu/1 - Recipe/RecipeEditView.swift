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
  
  private var persistenceController = PersistenceController.shared
  private var recipeEntity: RecipeEntity? = nil
  private var maltEntities: [MaltEntity]? = nil
  
  @State var recipeName: String = ""
  @State var recipeStyle: String = ""
  @State var recipeBatchSize: String = ""
  @State var recipeOG: Float = 0.0
  @State var recipeFG: Float = 0.0
  
  @State var recipeHops: String = ""
  @State var recipeYeast: String = ""
  
  @State var showAlert: Bool = false
  
  init(recipeEntity: RecipeEntity, maltEntities: [MaltEntity]) {
    self.recipeEntity = recipeEntity
    _recipeName = State(initialValue: recipeEntity.name ?? "error")
    _recipeStyle = State(initialValue: recipeEntity.style ?? "error")
    
    self.maltEntities = maltEntities
  }
  
  init() {
  }
  
  var body: some View {
    VStack {
      VStack (alignment: .center){
        Section(header: SectionHeader(title: "General")){
          generalSectionRow(title: "Name",
                            contentValue: recipeName,
                            bindingValue: $recipeName)
          generalSectionRow(title: "Style",
                            contentValue: recipeStyle,
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
          displayMaltsRow(maltEntities: maltEntities)
            .padding(.bottom, 20)
        }
      }
      .padding()
      .navigationTitle("Recipe Details")
      .navigationBarItems(trailing: Button(action: {
        if (recipeEntity != nil){
          recipeEntity?.name = recipeName
          recipeEntity?.style = recipeStyle
          persistenceController.saveData()
          presentationMode.wrappedValue.dismiss()
        }
        else if (persistenceController.doesRecipeNameExist(name: recipeName)){
          showAlert = true
        }
        else {
          let newEntity = RecipeEntity(context: persistenceController.container.viewContext)
          newEntity.name = recipeName
          newEntity.og = recipeOG
          newEntity.style = recipeStyle
          newEntity.fg = recipeFG
          persistenceController.addRecipe(_recipe: newEntity)
          presentationMode.wrappedValue.dismiss()
        }
      })
                          {
        Text("Save")
      }
                            .disabled(recipeName.isEmpty)
                            .alert(isPresented: $showAlert, content: {
        Alert(
          title: Text("Warning!"),
          message: Text("Recipe name already exist!"),
          dismissButton: .cancel())
      }))
      Spacer()
    }
  }
}

struct generalSectionRow: View {
  var title: String
  var contentValue: String
  
  @Binding var bindingValue: String
  var titleTextFrameSizeH: CGFloat = 80
  var titleTextFrameSizeV: CGFloat = 20
  
  var body: some View {
    HStack{
      Text(title)
        .frame(width: titleTextFrameSizeH,
               height: titleTextFrameSizeV,
               alignment: .leading)
      TextField("",
                text: $bindingValue)
        .overlay(VStack{
          Divider()
            .background(Color.gray)
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
  var maltEntities : [MaltEntity]?
  
  var body: some View {
    HStack {
      HStack{
        Text("Malts")
          .frame(width: 80,
                 height: 20,
                 alignment: .leading)
        List {
          if let maltEntities = maltEntities {
            ForEach (maltEntities) {malt in
              if
                let malt = malt,
                let name = malt.name {
                Text("String \(name)")
              }
            }
          }
          
        }
        addOrRemoveButton()
      }
    }
  }}
  
  struct addOrRemoveButton: View {
    let imageSystemName = "plusminus"
    @State var isAddIngredientsViewActive = false
    
    var body: some View {
      NavigationLink(
        destination: AddMaltsView(),
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
      NavigationView{
        RecipeEditView()
          .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
      }
      NavigationView {
        RecipeEditView()
          .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
          .preferredColorScheme(.dark)
      }
    }
  }

