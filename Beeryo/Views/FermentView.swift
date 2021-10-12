//
//  BoilView.swift
//  Beeryo
//
//  Created by Jacek K on 12/10/2021.
//

import SwiftUI

struct FermentView: View {
  
  var recipeEntity: RecipeEntity
  
  init(recipeEntity: RecipeEntity) {
    self.recipeEntity = recipeEntity
  }
  
  var body: some View {
    VStack {
      
    }
    
  }
}


struct FermentView_Previews: PreviewProvider {
  static var previews: some View {
    FermentView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
    FermentView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity()).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
