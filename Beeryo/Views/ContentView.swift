//
//  ContentView.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  var body: some View {
    SplashView()
      .onAppear(perform: {
      })
  }
  
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
      ContentView()
        .preferredColorScheme(.dark)
      
    }}
}
