//
//  AddIngredientsView.swift
//  Beeryo
//
//  Created by Jacek K on 02/09/2021.
//

import SwiftUI

struct AddIngredientsView: View {
  var passedRecipeEntity: RecipeEntity? = nil
  
  init(){
   
  }
  
  init(recipe: RecipeEntity){
    passedRecipeEntity = recipe
  }
    var body: some View {
      Text("Add malts for \(passedRecipeEntity?.name ?? "")")
    }
}

struct AddIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientsView()
    }
}
