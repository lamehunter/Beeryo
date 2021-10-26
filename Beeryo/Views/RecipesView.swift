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
  @Environment(\.colorScheme) private var colorScheme
  
  @State var isNewRecipeVisible = false
  @State var newRecipeName: String = ""
  @State var isAlertPresented = false
  
  init() {
    
  }
  
  //initizalizer just for preview purposes
  init(previewController: PersistenceController) {
    _persistenceController = StateObject(wrappedValue: previewController)
    
  }
  
  var body: some View {
    VStack {
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
      .listStyle(.plain)
      Spacer()
      HStack() {
        TextField("New recipe name", text: $newRecipeName)
          .padding()
        Spacer()
        Button {
          if (persistenceController.doesRecipeNameExist(name: newRecipeName) || newRecipeName.isEmpty) {
            isAlertPresented = true
          }
          else {
            persistenceController.addRecipeByName(_recipeName: newRecipeName)
            newRecipeName = ""
          }
        } label: {
          Text("Add New")
            .padding(10)
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10)
            .padding()
        }
      }
      .background(Color.gray.opacity(0.2))
      .cornerRadius(15)
      .padding()
      .alert(isPresented: $isAlertPresented) {
        Alert(title: Text("Warning"), message: Text("Recipe name is empty or it already exist!"), dismissButton: .cancel())
      }
      .navigationBarTitle("My Recipes", displayMode: .inline)
      .navigationViewStyle(StackNavigationViewStyle())
      .onAppear() {
        if (colorScheme == .light) {
          UINavigationBar.appearance().tintColor = .black
        }
        else {
          UINavigationBar.appearance().tintColor = .white
        }
      }
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
