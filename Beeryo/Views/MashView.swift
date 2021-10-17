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
      HStack {
        Text("Infusion mashing")
          .bold()
        Spacer()
      }
      .padding(.bottom, 5)
      HStack {
        Text("Step list:")
          .bold()
        Spacer()
      }
      List {
        if let mashSteps = recipeEntity.stepsMashing?.allObjects as? [StepMashingEntity],
            let mashStepsSorted = mashSteps.sorted(by: {$0.index < $1.index}) {
          ForEach (mashStepsSorted, id: \.index) { step in
            if
              let no = step.index,
              let temp = step.temperature,
              let duration = step.duration {
                HStack {
                  Text("No. \(no+1)")
                    .foregroundColor(Color("TextColor"))
                  Spacer()
                  Text("\(temp)°C for \(duration)min")
                    .foregroundColor(Color("TextColor"))
                }
            }
          }
          .onDelete(perform: { indexSet in
            indexSet.forEach { index in
              if let mashSteps = recipeEntity.stepsMashing?.allObjects as? [StepMashingEntity] {
                let mashStepsSorted = mashSteps.sorted(by: {$0.index < $1.index})
                persistenceController.deleteMashStep(mashStepEntities: mashStepsSorted, index: index)
              }
            }
          })
          .listRowBackground(Color.gray.opacity(0.2))
          .padding(.bottom, 10)
        }
      }
      
      TextFieldGeneralView(title: "Temp", text: "", bindingValue: $stepTemp)
        .keyboardType(.decimalPad)
      TextFieldGeneralView(title: "Duration", text: "", bindingValue: $stepDuration)
        .keyboardType(.decimalPad)
        .padding(.bottom, 10)
      Button {
        persistenceController.addMashStepToRecipe(temp: stepTemp, duration: stepDuration, note: "", recipeEntity: recipeEntity)
      } label: {
        Text("Add step")
          .frame(maxWidth: .infinity)
          .padding()
          .foregroundColor(.white)
          .background(Color.black)
          .cornerRadius(15.0)
      }
      .disabled(stepTemp.isEmpty && stepDuration.isEmpty)
    }
    .padding()
    .onTapGesture(perform: {
      UIApplication.shared.endEditing()
    })
  }
}

struct MashView_Previews: PreviewProvider {
  static var previews: some View {
    MashView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
    MashView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity()).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
