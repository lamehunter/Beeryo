//
//  MaltClass.swift
//  Beeryo
//
//  Created by Jacek K on 02/09/2021.
//

class Malt : Ingredient {
  let color: String
  
  init(name: String, quantity: Float, quantityUnit: QuantityUnit, color: String) {
    self.color = color
    super.init(name: name,
               quantity: quantity,
               quanityUnit: quantityUnit)
  }
}
