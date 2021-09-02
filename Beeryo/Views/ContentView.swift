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
  
  static func PopulateWithTestData() {
    
  }
  
  private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
  }
  
  private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
  }
  
  
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }}
}
