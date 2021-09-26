//
//  AddMaltsView.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//

import SwiftUI

struct AddMaltsView: View {
  @State var maltName: String = ""
  @State var maltWeight: Float = 0.0
  @State var maltWeightString: String = ""
  @ObservedObject var persistenceController = PersistenceController.shared
 
  func convertWeight(){
    maltWeight = Float(maltWeightString) ?? 0.0
  }
  
  func areInputsValid() -> Bool {
    if maltName.isEmpty || maltWeight <= 0.0 { return false }
    else { return true }
  }
  
  var body: some View {
    VStack {
      List {
        ForEach(persistenceController.allMalts) { malt in
          if let malt = malt,
             let name = malt.name {
          Text("\(name)")
          }
        }
      }
      Text("Add malts")
      HStack{
        Text("Malt name:")
        TextField("Malt name: ", text: $maltName)
      }
      .padding()
      
      HStack{
        Text("Malt weight:")
        TextField("Malt weight: ", text: $maltWeightString).keyboardType(.decimalPad)
      }
      .padding()
      
    }
    .padding()
    .navigationTitle("Add malts")
    .navigationBarItems(trailing: Button(action: {
      convertWeight()
      if areInputsValid() {
        persistenceController.addMalt(name: maltName, weight: maltWeight)
      }
      else { return }
    }, label: {
      Text("Add")
    }))
    
  }
}

struct AddMaltsView_Previews: PreviewProvider {
  static var previews: some View {
    AddMaltsView()
  }
}
