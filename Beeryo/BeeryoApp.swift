//
//  BeeryoApp.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI
import Combine

@main
struct BeeryoApp: App {
  
  //line needed for foreground notifications
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  let persistenceContainer = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
      .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
    }
  }
  
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif



