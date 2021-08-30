//
//  AddRecipeView.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI

struct AddRecipeView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @State var recipeName: String = ""
  
    var body: some View {
      VStack{
        TextField("Beer Name", text: $recipeName)
        
        Button(action: {
          RecipeEntity.createWith(recipeName: recipeName, using: viewContext)
        }) {
          Text("button TExt")
        }
        
      }
      
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
      AddRecipeView()
    }
}
