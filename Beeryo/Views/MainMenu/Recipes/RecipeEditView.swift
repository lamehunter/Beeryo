//
//  AddRecipeView.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI

struct RecipeEditView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @State var recipeName: String = ""
  @State var batchSize: Float = 0.0
  
  var body: some View {
    VStack{
      Header()
      RowTextFieldUnderlined(text: "Name", data: $recipeName)
      RowTextFieldUnderlined(text: "Style", data: $recipeName)
      RowTextFieldUnderlined(text: "Batch size", data: $recipeName)
    }
    .padding()
    .navigationBarItems(trailing: Button(action: {
      
    }) {
      Text("SaveButton")
    })
    
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

struct Header: View {
  var body: some View {
    Text("Recipe Details")
      .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
  }
}

struct RecipeEditView_Previews: PreviewProvider {
  static var previews: some View {
    RecipeEditView()
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
