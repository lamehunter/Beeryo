//
//  Yeast.swift
//  Beeryo
//
//  Created by Jacek K on 02/09/2021.
//

class Yeast : Ingredient {
  let yeastType: YeastType
  
  init(yeastType: YeastType, name: String, quantity: Float, quantityUnit: QuantityUnit) {
    self.yeastType = yeastType
    
    super.init(name: name,
               quantity: quantity,
               quanityUnit: quantityUnit)
  }
}

