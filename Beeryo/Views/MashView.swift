//
//  BoilView.swift
//  Beeryo
//
//  Created by Jacek K on 12/10/2021.
//

import SwiftUI

struct MashView: View {
  var recipeEntity: RecipeEntity
  @ObservedObject var persistenceController = PersistenceController.shared
  @State var stepTemp: String = ""
  @State var stepDuration: String = ""
  
  init(recipeEntity: RecipeEntity) {
    self.recipeEntity = recipeEntity
  }
  
  var body: some View {
    VStack {
      List {
        if let mashSteps = recipeEntity.stepsMashing?.allObjects as? [StepMashingEntity] {
          ForEach (mashSteps.sorted(by: {$0.index < $1.index})) { step in
            if
              let index = step.index,
              let temp = step.temperature,
              let duration = step.duration {
                HStack {
                  Text("No. \(index+1)")
                    .foregroundColor(Color("TextColor"))
                  Spacer()
                  Text("\(temp)C")
                    .foregroundColor(Color("TextColor"))
                  Text("\(duration)min")
                    .foregroundColor(Color("TextColor"))
                }
            }
          }
          .onDelete(perform: { indexSet in
            indexSet.forEach { index in
              persistenceController.deleteMashStep(recipeEntity: recipeEntity, index: index)
            }
          })
          .listRowBackground(Color.gray.opacity(0.2))
          .padding(.bottom, 10)
        }
      }
     
      
      Text("Set infusion mashing step")
      TextFieldGeneralView(title: "Temp", text: "", bindingValue: $stepTemp)
      TextFieldGeneralView(title: "Duration", text: "", bindingValue: $stepDuration)
        .padding(.bottom, 10)
      Button {
        persistenceController.addMashStepToRecipe(temp: stepTemp, duration: stepDuration, note: "", recipeEntity: recipeEntity)
      } label: {
        Text("Add")
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(15.0)
      }
      .disabled(stepTemp.isEmpty && stepDuration.isEmpty)
    }
    .padding()
  }
}

struct MashView_Previews: PreviewProvider {
  static var previews: some View {
    MashView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
    MashView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity()).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
