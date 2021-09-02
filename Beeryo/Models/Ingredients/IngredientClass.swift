//
//  Ingredient.swift
//  Beeryo
//
//  Created by Jacek K on 02/09/2021.
//

class Ingredient {
  var name: String
  var quantity: Float
  var quantityUnit: QuantityUnit
  
  init(name: String, quantity: Float, quanityUnit: QuantityUnit) {
    self.name = name
    self.quantity = quantity
    self.quantityUnit = quanityUnit
  }
}


