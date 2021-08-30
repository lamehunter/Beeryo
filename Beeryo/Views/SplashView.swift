//
//  SplashView.swift
//  Beeryo
//
//  Created by Jacek K on 30/08/2021.
//

import SwiftUI

struct SplashView: View {
  
  @State var isMainMenuActive:Bool = false
  
  var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  
  var body: some View {
    VStack {
      if self.isMainMenuActive {
        MainMenuView()
      } else {
        Spacer()
        Image("beerSplashScreenLogo")
          .resizable()
          .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        Text("Beeryo")
          .font(Font.largeTitle)
          .bold()
        Spacer()
        HStack{
          Text("It's a brew time!")
            .font(.footnote)
            .fontWeight(.bold)
            .padding(.bottom, 20)
          Spacer()
          Text("Ver. " + version!)
            .font(.footnote)
            .fontWeight(.bold)
            .padding(.bottom, 20)
        }
        .padding(10)
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
        withAnimation {
          self.isMainMenuActive = true
        }
      }
    }
  }
  
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
  }
}
