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
                animation: .default)
  private var items: FetchedResults<RecipeEntity>
  
  @State var recipeName: String = ""
  @State var recipeStyle: String = ""
  @State var recipeBatchSize: String = ""
  @State var recipeOG: String = ""
  @State var recipeFG: String = ""
  
  @State var showAlert: Bool = false
  @State var alertText = ""
  
  init(valueee: String) {
    _recipeName = State(initialValue: valueee)
  }
  
  var body: some View {
    VStack (alignment: .center){
      Section(header: SectionHeader(title: "General")){
        RowTextFieldUnderlined(text: "Name", data: $recipeName)
        RowTextFieldUnderlined(text: "Style", data: $recipeStyle)
        RowTextFieldUnderlined(text: "Batch size", data:
                               $recipeBatchSize)
        RowTextFieldUnderlined(text: "OG", data: $recipeStyle)
        RowTextFieldUnderlined(text: "FG", data: $recipeBatchSize)
          .padding(.bottom, 20)
      }
      
      Section(header: SectionHeader(title: "Ingredients")){
        RowTextFieldUnderlined(text: "Name", data: $recipeName)
        RowTextFieldUnderlined(text: "Style", data: $recipeStyle)
        RowTextFieldUnderlined(text: "Batch size", data: $recipeBatchSize)
          .padding(.bottom, 20)
      }
     
    }
    .padding()
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
        RecipeEntity.createWith(recipeName: recipeName, using: viewContext)
        presentationMode.wrappedValue.dismiss()
      }
      
    }) {
      Text("Save")
    }.alert(isPresented: $showAlert, content: {
      Alert(title: Text("Text Field"), message: Text(alertText), dismissButton: .destructive(Text("Dismiss")))
    })
    )
  }
}

struct RowTextFieldUnderlined: View {
  var text: String
  @Binding var data: String
  var titleTextFrameSizeH: CGFloat = 80
  var titleTextFrameSizeV: CGFloat = 20
  
  var body: some View {
    HStack{
      Text(text)
        .frame(width: titleTextFrameSizeH, height: titleTextFrameSizeV, alignment: .leading)
      TextField(text, text: $data)
        .overlay(VStack{
                  Divider()
                    .background(Color.red)
                    .offset(x: 0, y: 15)})
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
    RecipeEditView(valueee: "Mkay")
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
