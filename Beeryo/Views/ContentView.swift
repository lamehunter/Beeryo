//
//  ContentView.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  var body: some View {
    SplashView()
      .onAppear(perform: {
        // populate entity with test data
//        RecipeEntity.createWith(
//          recipeName: "test data 1",
//          using: viewContext)
//        RecipeEntity.createWith(
//          recipeName: "test data 2",
//          using: viewContext)
//        RecipeEntity.createWith(
//          recipeName: "test data 3",
//          using: viewContext)
//        RecipeEntity.createWith(
//          recipeName: "test data 4",
//          using: viewContext)
        
      })
  }
  
  
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
        
    }}
}
