//
//  BoilView.swift
//  Beeryo
//
//  Created by Jacek K on 12/10/2021.
//

import SwiftUI

struct MashView: View {
  
  var recipeEntity: RecipeEntity
  
  init(recipeEntity: RecipeEntity) {
    self.recipeEntity = recipeEntity
  }
  
  var body: some View {
    VStack {
      
    }
    
  }
}


struct MashView_Previews: PreviewProvider {
  static var previews: some View {
    MashView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
    MashView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity()).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
