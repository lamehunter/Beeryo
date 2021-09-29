//
//  RecipesView.swift
//  Beeryo
//
//  Created by Jacek K on 30/08/2021.
//

import SwiftUI

struct RecipesView: View {
  @StateObject var persistenceController = PersistenceController.shared
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @State var isNewRecipeVisible = false
  @State var newRecipeName: String = ""
  @State var isAlertPresented = false
  
  init(){
    
  }
  
  //initizalizer just for preview purposes
  init(previewController: PersistenceController) {
    _persistenceController = StateObject(wrappedValue: previewController)
  }
  
  var body: some View {
    VStack {
//      NavigationLink(
//        destination: RecipeEditView(),
//        isActive: $isNewRecipeVisible
//      ) {
//        //EmptyView()
//      }
      List {
        ForEach(persistenceController.allRecipes) { item in
          if let item = item {
            NavigationLink(item.name!,
                           destination: RecipeEditView(recipeEntity: item)
            )
          }
        }.onDelete(perform: { indexSet in
          indexSet.forEach { index in
            persistenceController.deleteRecipe(index: index)
          }
        })
      }
      Spacer()
      HStack() {
        TextField("Name...", text: $newRecipeName)
        Spacer()
        Button {
          if persistenceController.doesRecipeNameExist(name: newRecipeName) {
            isAlertPresented = true
          }
          else {
            persistenceController.addRecipeByName(_recipeName: newRecipeName)
            newRecipeName = ""
          }
        } label: {
          Text("Add New")
        }
        .disabled(newRecipeName.isEmpty)
      }
      .padding()
      .alert(isPresented: $isAlertPresented) {
        Alert(title: Text("Warning"), message: Text("Recipe already exist"), dismissButton: .cancel())
      }
      .navigationBarTitle("My Recipes", displayMode: .inline)
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}

struct RecipesView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RecipesView(previewController: PersistenceController.preview)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
  }
}
