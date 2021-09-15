//
//  BeeryoApp.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI

@main
struct BeeryoApp: App {
  let persistenceContainer = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceContainer.container.viewContext)}
  }
}

