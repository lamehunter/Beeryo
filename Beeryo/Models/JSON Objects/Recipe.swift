//
//  Recipe.swift
//  Beeryo
//
//  Created by Jacek K on 22/09/2021.
//

class Recipe {
  let name : String
  let style : String
  let og : Float
  let fg : Float
  
  init(name: String, style: String, og: Float, fg: Float){
    self.name = name
    self.style = style
    self.og = og
    self.fg = fg
  }
}
