//
//  BoilView.swift
//  Beeryo
//
//  Created by Jacek K on 12/10/2021.
//

import SwiftUI

struct BoilView: View {
  let hopUnit = "g"
  let timeUnit = "min"
  @StateObject var recipeEntity: RecipeEntity
  @State var startDate = Date()
  @State var endDate = Date()
  @State var timerIsActive = false
  @State var boilLength: String = ""
  @State var hopsWithSetTime: [(String, String, Date)] = []
  var notification = Notification.shared
  @State var isBoilValidationAlertVisible: Bool = false
  @ObservedObject var persistenceController = PersistenceController.shared
  
  init(recipeEntity: RecipeEntity) {
    _recipeEntity = StateObject(wrappedValue: recipeEntity)
    let duration = recipeEntity.boilDetails?.duration ?? 0
    let durationString = String(duration)
    _boilLength = State(initialValue: durationString)
  }
  
  var timeFormat: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm:ss a"
    return formatter
  }
  
  func timeString(date: Date) -> String {
    let time = timeFormat.string(from: date)
    return time
  }
  
//  var updateTimer: Timer {
//    Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
//                         block: {_ in
//      startDate = Date()
//    })
//  }
  
  func GetHopNameAndTime() -> [(String, String, Date)] {
    var array: [(String, String, Date)] = []
    if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {for hop in
                                                                              hopEntities.sorted(by: {$0.duration > $1.duration}) {
      let difference: Int = (Int(boilLength) ?? 0) - Int(hop.duration)
      let hopEndDate: Date = SetEndDate(minutes: String(difference))
      array.append((hop.name ?? "", String(hop.weight), hopEndDate))
    }
    }
    return array
  }
  
  func SetEndDate(minutes: String) -> Date {
    let minutesInt: Int = Int(minutes) ?? 0
    let endDate = Calendar.current.date(byAdding: DateComponents(minute: minutesInt), to: startDate)
    return endDate!
  }
  
  func IsBoilTimeValidValue() -> Bool {
    if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
      let hopEntitiesSorted = hopEntities.sorted(by: {$0.duration > $1.duration})
      if (hopEntitiesSorted[0].duration > (Int32(boilLength) ?? 0)) {
        return false
      }
      else {
        return true
      }
    }
    return false
  }
  
  var body: some View {
    VStack {
      SectionHeader(title: "Boil Duration")
      
      HStack {
        TextField("",
                  text: $boilLength)
          .keyboardType(.decimalPad)
          .multilineTextAlignment(.center)
          .overlay(VStack {
            Divider()
              .background(Color("TextColor"))
            .offset(x: 0, y: 15)})
        Text("\(timeUnit)")
      }
      .navigationBarItems(trailing: Button(action: {
        if (persistenceController.doesBoilEntityExist(recipe: recipeEntity) == true) {
          recipeEntity.boilDetails?.recipe = recipeEntity
          recipeEntity.boilDetails?.duration = Int16(boilLength) ?? 0
          persistenceController.saveData()
        }
            else {
              persistenceController.addBoilEntityToRecipe(duration: boilLength, note: "", recipeEntity: recipeEntity)
        }
      }, label: {
        Text("Save")
      }))
      
      if timerIsActive {
        HStack {
          Text("Start: \(timeString(date: startDate))")
          Spacer()
          Text("End: \(timeString(date: endDate))")
        }
        .onAppear {
          startDate = Date()
          endDate = SetEndDate(minutes: boilLength)
          hopsWithSetTime = GetHopNameAndTime()
          
        }
        
        ForEach(Array(hopsWithSetTime), id: \.0) { item in
          HStack {
            Text("Add \(item.0) - \(item.1)g @ \(timeString(date: item.2))")
            Spacer()
          }
            .onAppear() {
              let delayedDate = Calendar.current.date(byAdding: .second, value: 5, to: item.2)
              notification.AddNotification(title: "Alert", body: "Add \(item.0) - \(item.1)g @ \(item.2)", exactDate: delayedDate ?? item.2)
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .padding(1)
            .cornerRadius(5)
        }
      }
      
      HStack {
        Spacer()
        
        Button(action: {
          if IsBoilTimeValidValue() {
            timerIsActive = true
          }
          else {
            isBoilValidationAlertVisible = true
          }
        }) {
          Image(systemName: timerIsActive ? "play.fill" : "play")
            .resizable()
            .frame(width: 20, height: 20)
        }
        .foregroundColor(Color("TextColor"))
        
        Spacer()
        
        Button(action: {
          timerIsActive = false
          
        }) {
          Image(systemName: timerIsActive ? "stop" : "stop.fill")
            .resizable()
            .frame(width: 20, height: 20)
        }
        .foregroundColor(Color("TextColor"))
        
        Spacer()
      }
      .alert(isPresented: $isBoilValidationAlertVisible) {
        return Alert(title: Text("Alert"), message: Text("Boil duration must be greater or equal longest hopping duration"), dismissButton: .cancel())
      }
      
      SectionHeader(title: "Additions")
      if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
        ForEach (hopEntities.sorted(by: {$0.duration > $1.duration})) { hop in
          if
            let name = hop.name,
            let weight = hop.weight,
            let duration = hop.duration {
            HStack {
              Text("\(name), ")
                .font(.footnote)
              Spacer()
              Text("\(weight)\(hopUnit)")
                .font(.footnote)
              Text("\\")
                .font(.footnote)
              Text("\(duration)min")
                .font(.footnote)
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .padding(1)
            .cornerRadius(5)
          }
        }
      }
      Spacer()
    }
    .padding()
    
  }
}


struct BoilView_Previews: PreviewProvider {
  static var previews: some View {
    BoilView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
    BoilView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity()).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
