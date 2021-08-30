////
////  ContentViewTest.swift
////  Beeryo
////
////  Created by Jacek K on 29/08/2021.
////
//
//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//  @Environment(\.managedObjectContext) private var viewContext
//
//  var fetchRequest = RecipeEntity.fetchRequest1()
//
//  @FetchRequest(entity: RecipeEntity.entity(),
//                sortDescriptors: [],
//                animation: .default)
//  private var items: FetchedResults<RecipeEntity>
//
//  var body: some View {
//
//    VStack{
//      Text("hello")
//
//      Button(action: {
//        for i in 0..<10 {
//          let newItem = RecipeEntity(context: viewContext)
//          newItem.recipeName = "Nr" + String(i)
//          print(newItem.recipeName! + "/ added")
//
//          do {
//            try viewContext.save()
//          } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//          }
//        }
//      }) {
//        Text("Add elements")
//      }
//
//      Button(action: {
//
//        for number in 0...(items.count - 1) {
//          guard let recipeName = items[number].recipeName
//          else {
//            return
//          }
//          print("Number: " + String(number) + " RecipeName: " + recipeName)
//        }
//
//      }) {
//        Text("Fetch Results")
//      }
//
//
//      List{
//        ForEach(items) { item in
//          Text(item.recipeName!)
//        }
//      }
//    }
//  }
//
//  private func addItem() {
//    //        withAnimation {
//    //            let newItem = Item(context: viewContext)
//    //            newItem.timestamp = Date()
//    //
//    //            do {
//    //                try viewContext.save()
//    //            } catch {
//    //                // Replace this implementation with code to handle the error appropriately.
//    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//    //                let nsError = error as NSError
//    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//    //            }
//    //        }
//  }
//
//  private func deleteItems(offsets: IndexSet) {
//    //        withAnimation {
//    //            offsets.map { items[$0] }.forEach(viewContext.delete)
//    //
//    //            do {
//    //                try viewContext.save()
//    //            } catch {
//    //                // Replace this implementation with code to handle the error appropriately.
//    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//    //                let nsError = error as NSError
//    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//    //            }
//    //        }
//    //    }
//  }
//
//
//  struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//      ContentView()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }}
//}
