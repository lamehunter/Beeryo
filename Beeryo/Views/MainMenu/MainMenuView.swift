//
//  MainMenu.swift
//  Beeryo
//
//  Created by Jacek K on 30/08/2021.
//

import SwiftUI

struct MainMenuView: View {
  let vStackSpacing: CGFloat = 20
  
  var body: some View {
    NavigationView{
      VStack (alignment: .leading, spacing: vStackSpacing){
        Button(action: {
        }) {
          NavigationLink(
            destination: RecipesView()){
            MenuRowView(imageSystemName: "doc.text", rowName: "Recipes")
          }
        }
        MenuRowView(imageSystemName: "archivebox", rowName: "Store")
      }}
  }
}


struct MenuRowView : View {
  let imageSystemName: String
  let rowName: String
  
  let menuPositionImageSize: CGFloat = 25
  let paddingLeftMenuPosition: CGFloat = 20
  
  var body: some View {
    HStack{
      Image(systemName: imageSystemName)
        .resizable()
        .frame(width: menuPositionImageSize, height: menuPositionImageSize)
      Text(rowName)
        .bold()
        .font(.title)
        .padding(.leading, paddingLeftMenuPosition)
    }
  }
}

struct MainMenuView_Previews: PreviewProvider {
  static var previews: some View {
    MainMenuView()
  }
}
