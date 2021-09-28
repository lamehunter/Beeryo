//
//  MainMenu.swift
//  Beeryo
//
//  Created by Jacek K on 30/08/2021.
//

import SwiftUI

struct MainMenuView: View {
  let vStackSpacing: CGFloat = 10
  let screenWidth = CGFloat(UIScreen.main.bounds.size.width)
  let screenHeight = CGFloat(UIScreen.main.bounds.size.height)
  lazy var backgroundImageSize = screenWidth < screenHeight ? screenWidth : screenHeight
  
  var body: some View {
    NavigationView {
      ZStack {
        VStack (alignment: .leading, spacing: vStackSpacing){
          TitleRow(text: "Let's start ...", textPosition: "left")
          Button(action: {
          }) {
            NavigationLink(
              destination: RecipesView()){
              MenuRowView(imageSystemName: "doc.text", text: "My Recipes")
            }
          }
          .buttonStyle(MainMenuButtonStyle())
          MenuRowView(imageSystemName: "archivebox", text: "Ingredients storage")
          Button(action: {
          }) {
            NavigationLink(
              destination: RecipesView()){
              MenuRowView(imageSystemName: "doc.text", text: "Upload recipes")
            }
          }
          .buttonStyle(MainMenuButtonStyle())
          Button(action: {
          }) {
            NavigationLink(
              destination: RecipesView()){
              MenuRowView(imageSystemName: "doc.text", text: "Download recipes")
            }
          }
          .buttonStyle(MainMenuButtonStyle())
          Spacer()
          TitleRow(text: "... brewing!", textPosition: "right")
        }
        .navigationBarHidden(true)
        Image("beerSplashScreenLogo")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(Color("TextColor"))
          .opacity(0.05)
          .frame(width: screenWidth < screenHeight ? screenWidth : screenHeight,
                 height: screenWidth < screenHeight ? screenWidth : screenHeight)
      }
    }
  }
}

struct MainMenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .background(Color.clear)
            .foregroundColor(Color("TextColor"))
            
    }
}

struct TitleRow : View {
  let text: String
  let textPosition: String
  
  var body: some View {
    HStack {
      if (textPosition == "left"){
        Text(text)
          .bold()
          .font(.title)
          .padding(.leading, 10)
        Spacer()
      }
      else if (textPosition == "right"){
        Spacer()
        Text(text)
          .bold()
          .font(.title)
          .padding(.leading, 10)
      }
    }
    .padding(5)
    .padding(.leading, 20)
    .padding(.trailing, 20)
  }
}

struct MenuRowView : View {
  let imageSystemName: String
  let text: String
  
  let menuPositionImageSize: CGFloat = 20
  let paddingLeftMenuPosition: CGFloat = 20
  
  var body: some View {
    HStack {
      Image(systemName: imageSystemName)
        .resizable()
        .frame(width: menuPositionImageSize, height: menuPositionImageSize)
        .padding(.leading, 10)
      Text(text)
        .bold()
        .font(.body)
        .padding(.leading, 10)
      
    }
    .padding(5)
    .frame(maxWidth: .infinity, alignment: .leading)
    .overlay(
      RoundedRectangle(cornerRadius: 5)
        .stroke(Color("StrokeColor"), lineWidth: 1)
        .opacity(0.3))
    .padding(.leading, 20)
    .padding(.trailing, 20)
  }
}

struct MainMenuView_Previews: PreviewProvider {
  static var previews: some View {
    MainMenuView()
    MainMenuView()
      .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
