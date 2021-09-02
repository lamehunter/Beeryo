//
//  HopClass.swift
//  Beeryo
//
//  Created by Jacek K on 02/09/2021.
//

class Hop : Ingredient {
  var when: String
  var howLong: Int
  var howLongUnit: TimeUnit
  
  init(name: String, quantity: Float, quantityUnit: QuantityUnit, when: String, howLong: Int, howLongUnit: TimeUnit) {
    self.when = when
    self.howLong = howLong
    self.howLongUnit = howLongUnit
    super.init(name: name, quantity: quantity, quanityUnit: quantityUnit)
  }
  
  func displayDetails() -> String {
    "\(name): \(quantity) \(quantityUnit), \(howLong) \(howLongUnit) \(when)"
  }
}
