//
//  BeeryoApp.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI

@main
struct BeeryoApp: App {
  
  //line needed for foreground notifications
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  let persistenceContainer = PersistenceController.shared
  //let notification = Notification.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceContainer.container.viewContext)}
      
  }
}

