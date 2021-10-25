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
  @State var isValidationAlertShown: Bool = false
  
  let unitsTemp = "°C"
  let unitsDuration = "min"
  
  init(recipeEntity: RecipeEntity) {
    self.recipeEntity = recipeEntity
  }
  
  func validationIsPassed() -> Bool {
    if (!stepTemp.isEmpty &&
        !stepDuration.isEmpty &&
        Int(stepTemp) ?? 0 > 0 &&
        Int(stepDuration) ?? 0 > 0) {
      return true
    }
    else {
      return false
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Text("Infusion mashing")
          .bold()
        Spacer()
      }
      .padding(.bottom, 5)
      
      List {
        if let mashSteps = recipeEntity.stepsMashing?.allObjects as? [StepMashingEntity],
           let mashStepsSorted = mashSteps.sorted(by: {$0.index < $1.index}) {
          if mashSteps.count > 0 {
            HStack {
              Spacer()
              Text("Step list:")
                .bold()
              Spacer()
            }
          }
          ForEach (mashStepsSorted, id: \.index) { step in
            if
              let no = step.index,
              let temp = step.temperature,
              let duration = step.duration {
              HStack {
                Text("No. \(no+1)")
                  .foregroundColor(Color("TextColor"))
                Spacer()
                Text("\(temp)\(unitsTemp) for \(duration)\(unitsDuration)")
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
      .listStyle(PlainListStyle())
      
      TextFieldGeneralView(title: "Temp (\(unitsTemp))", text: "", bindingValue: $stepTemp)
        .keyboardType(.decimalPad)
      TextFieldGeneralView(title: "Duration (\(unitsDuration))", text: "", bindingValue: $stepDuration)
        .keyboardType(.decimalPad)
        .padding(.bottom, 10)
      Button {
        if validationIsPassed() {
          persistenceController.addMashStepToRecipe(temp: stepTemp, duration: stepDuration, note: "", recipeEntity: recipeEntity)
          hideKeyboard()
        }
        else {
          isValidationAlertShown = true
        }
      } label: {
        Text("Add step")
          .frame(maxWidth: .infinity)
          .padding()
          .foregroundColor(.white)
          .background(Color.black)
          .cornerRadius(15.0)
      }
      .alert(isPresented: $isValidationAlertShown, content: {
        return Alert(title: Text("Field Validation Alert"),
                     message: Text("Fields can't be empty & temperature and duration greater than zero"),
                     dismissButton: .cancel())
      })
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
