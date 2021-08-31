//
//  RecipesView.swift
//  Beeryo
//
//  Created by Jacek K on 30/08/2021.
//

import SwiftUI


struct RecipesView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @State var isNewRecipeVisible = false
  var fetchRequest = RecipeEntity.fetchRequest1()
  
  @FetchRequest(entity: RecipeEntity.entity(),
                sortDescriptors: [],
                animation: .default)
  private var items: FetchedResults<RecipeEntity>
  
  var body: some View {
    NavigationLink(
      destination: RecipeEditView(),
      isActive: $isNewRecipeVisible
    ) {
      EmptyView()
    }
    
    List {
      
      ForEach(items){item in
        NavigationLink(item.name!, destination: RecipeEditView())
      }
      NavigationLink("Recipe 1", destination: RecipeEditView())
      NavigationLink("Recipe 2", destination: RecipeEditView())
    }
    .navigationTitle("My Recipes")
    .navigationViewStyle(DefaultNavigationViewStyle())
    .navigationBarItems(
      trailing: NavigationBarRightButtonView(isNewRecipeVisible: $isNewRecipeVisible))
  }
}

struct NavigationBarRightButtonView: View {
  @Binding var isNewRecipeVisible: Bool
  var body: some View {
    
    Button(action: {
      isNewRecipeVisible = true
    }, label: {
      HStack {
        Image(systemName: "plus.circle")
          .resizable()
          .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        Text("New Recipe")
          .fontWeight(.semibold)
          .font(.headline)
      }
      // }
    })
  }
}

struct RecipesView_Previews: PreviewProvider {
  static var previews: some View {
    RecipesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
