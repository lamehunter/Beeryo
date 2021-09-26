//
//  AddMaltsView.swift
//  Beeryo
//
//  Created by Jacek K on 26/09/2021.
//

import SwiftUI

struct AddMaltsView: View {
  
  var body: some View {
    VStack{
      Text("Add malts")
    }
    .navigationTitle("Add malts")
    .navigationBarItems(trailing: Button(action: {
      
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
