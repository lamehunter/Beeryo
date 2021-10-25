//
//  BoilImageRandomizer.swift
//  Beeryo
//
//  Created by Jacek K on 21/10/2021.
//

import SwiftUI

struct BoilImageRandomizer {
  var imageCollection: [Image] = []
  
  init() {
    for n in 1...7 {
      imageCollection.append(Image("boil_image_\(n)"))
    }
  }
  
  func getRandomImage() -> Image {
    let random = Int.random(in: 0...6)
    return imageCollection[random]
  }
}
