//
//  AddMaltsView.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//

import SwiftUI

struct AddMaltsView: View {
  var unit = "kg"
  
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
             let name = malt.name,
             let weight = malt.weight {
            HStack{
              
              Text("\(name)")
              Spacer()
              Text(String.localizedStringWithFormat("%.2f %@", weight, unit))
              

            }
          }
        }
      }
      HStack{
        Text("Name:")
        TextField("Malt name", text: $maltName)
      }
      .padding()

      HStack{
        Text("Weight:")
        TextField("Malt weight", text: $maltWeightString).keyboardType(.decimalPad)
      }
      .padding()
      
      Button {
        convertWeight()
        if areInputsValid() {
          persistenceController.addMalt(name: maltName, weight: maltWeight)
        }
        else { return }
      } label: {
        Text("Add new malt")
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(15.0)
      }
    }
    .padding()
    .navigationTitle("Pick malts")
    .navigationBarItems(trailing: Button(action: {
      
    }, label: {
      Text("Save selection")
    }))
    
  }

}

struct AddMaltsView_Previews: PreviewProvider {
  static var previews: some View {
    AddMaltsView()
  }
}
