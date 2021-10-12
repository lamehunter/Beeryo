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
  var recipeEntity: RecipeEntity
  @State var startDate = Date()
  @State var endDate = Date()
  @State var timerIsActive = false
  @State var boilLength: String = "60"
  @State var hopAddDates: [Date] = []
  
  init(recipeEntity: RecipeEntity) {
    self.recipeEntity = recipeEntity
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
  
  var updateTimer: Timer {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                         block: {_ in
      startDate = Date()
    })
  }
  
  func setEndDate(minutes: String) -> Date {
    let minutesInt: Int = Int(minutes) ?? 0
    let endDate = Calendar.current.date(byAdding: DateComponents(minute: minutesInt), to: startDate)
    return endDate!
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
      
      if timerIsActive {
        HStack {
          Text("Start: \(timeString(date: startDate))")
          Spacer()
          Text("End: \(timeString(date: endDate))")
            .onAppear {
              endDate = setEndDate(minutes: boilLength)
              if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
                for hop in hopEntities.sorted(by: {$0.duration > $1.duration}) {
                  let hopEndDate: Date = setEndDate(minutes: String(hop.duration))
                  hopAddDates.append(hopEndDate)
                }
              }
              updateTimer
            }
        }
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
      }
      
      HStack {
        Spacer()
        
        Button(action: {
          timerIsActive = true
        }) {
          Image(systemName: "play")
            .resizable()
            .frame(width: 20, height: 20)
        }
        .foregroundColor(Color("TextColor"))
        
        Spacer()
        
        Button(action: {
          timerIsActive = false
        }) {
          Image(systemName: "stop")
            .resizable()
            .frame(width: 20, height: 20)
        }
        .foregroundColor(Color("TextColor"))
        
        Spacer()
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
