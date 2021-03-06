//
//  BoilView.swift
//  Beeryo
//
//  Created by Jacek K on 12/10/2021.
//

import SwiftUI

struct BoilView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let hopUnit = "g"
  let timeUnit = "min"
  @StateObject var recipeEntity: RecipeEntity
  @State var realtimeDateDisplayed = Date()
  @State var startDate = Date()
  @State var endDate = Date()
  @State var timerIsActive = false
  @State var boilLength: String = ""
  
  @State var hopsWithSetTime: [(String, String, Date)] = []
  @State var additionsWithSetTime: [(String, String, Date)] = []
  @State var combinedHopsAndAdditions: [(String, String, Date)] = []
  
  var notification = Notification.shared
  var boilImageRandomizer = BoilImageRandomizer()
  
  @State var boilDynamicImage: Image = Image("boil_image_noBubble")
  
  @State var timerBoil: Timer? = nil
  @State var timerImage: Timer? = nil
  
  @State var isBoilValidationAlertVisible: Bool = false
  @State var isBoilProcessActiveAlert: Bool = false
  
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
  
  func setBoilTimer() {
    timerBoil = Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                                     block: {_ in
      print("Date update")
      realtimeDateDisplayed = Date()
      if (realtimeDateDisplayed >= endDate) {
        print("boiling is finished")
        notification.AddNotification(title: "Alert", body: "Boiling process finished", exactDate: Date().advanced(by: 5))
        timerIsActive = false
        disableBoilTimer()
        disableImageTimer()
      }
    })
    print("Boil timer was set")
  }
  
  func setImageTimer() {
    timerImage = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true,
                                      block: {_ in
      boilDynamicImage = boilImageRandomizer.getRandomImage()
    })
    print("Image timer was set")
  }
  
  func disableBoilTimer() {
    timerBoil?.invalidate()
    print("Timer invalidated")
    timerBoil = nil
  }
  
  func disableImageTimer() {
    timerImage?.invalidate()
    print("Timer invalidated")
    timerImage = nil
    boilDynamicImage = Image("boil_image_noBubble")
  }
  
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
  
  func GetAdditionNameAndTime() -> [(String, String, Date)] {
    var array: [(String, String, Date)] = []
    if let additionEntities = recipeEntity.additions?.allObjects as? [AdditionEntity] {for addition in
                                                                                            additionEntities.sorted(by: {$0.duration > $1.duration}) {
      let difference: Int = (Int(boilLength) ?? 0) - Int(addition.duration)
      let additionEndDate: Date = SetEndDate(minutes: String(difference))
      array.append((addition.name ?? "", String(addition.weight), additionEndDate))
    }
    }
    return array
  }
  
  func GetAdditionsAndHopsCombined() -> [(String, String, Date)] {
    var array: [(String, String, Date)] = []
    array.append(contentsOf: GetHopNameAndTime())
    array.append(contentsOf: GetAdditionNameAndTime())
    let arraySorted = array.sorted { t1, t2 -> Bool in
      return t1.2 < t2.2
    }
    return arraySorted
  }
  
  func SetEndDate(minutes: String) -> Date {
    let minutesInt: Int = Int(minutes) ?? 0
    let endDate = Calendar.current.date(byAdding: DateComponents(minute: minutesInt), to: startDate)
    return endDate!
  }
  
  func IsBoilTimeValidValue() -> Bool {
    if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
      if !hopEntities.isEmpty {
        let hopEntitiesSorted = hopEntities.sorted(by: {$0.duration > $1.duration})
        if (hopEntitiesSorted[0].duration > (Int32(boilLength) ?? 0)) {
          return false
        }
        else {
          return true
        }
      }
    }
    return false
  }
  
  func playActions() {
    if IsBoilTimeValidValue() {
      timerIsActive = true
      hideKeyboard()
    }
    else {
      isBoilValidationAlertVisible = true
    }
  }
  
  func stopActions() {
    timerIsActive = false
    notification.RemoveAllNotifications()
    disableBoilTimer()
    disableImageTimer()
  }
  
  var body: some View {
    VStack {
      //Spacer()
      boilDynamicImage
        .resizable()
        .scaledToFit()
        .frame(maxWidth: 100)
        .foregroundColor(Color("TextColor"))
        .padding()
      
      SectionHeader(title: "Boil Duration & Timer")
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
      .navigationBarBackButtonHidden(true)
      .navigationBarItems(
        leading: Button(action: {
          if (timerIsActive) {
            isBoilProcessActiveAlert = true
          }
          else {
            presentationMode.wrappedValue.dismiss()
          }
        }, label: {
          HStack {
            Image(systemName: "chevron.backward")
            Text("Recipe Details")
              .foregroundColor(Color("TextColor"))
          }
        })
          .alert(isPresented: $isBoilProcessActiveAlert, content: {
            return Alert(title: Text("Alert"),
                         message: Text("Boil process was started. Stop the process before you go back"),
                         dismissButton: .cancel())
          }), trailing: Button(action: {
            if (persistenceController.doesBoilEntityExist(recipe: recipeEntity) == true) {
              recipeEntity.boilDetails?.recipe = recipeEntity
              recipeEntity.boilDetails?.duration = Int16(boilLength) ?? 0
              persistenceController.saveData()
            }
            else {
              persistenceController.addBoilEntityToRecipe(duration: boilLength, note: "", recipeEntity: recipeEntity)
            }
            presentationMode.wrappedValue.dismiss()
          }, label: {
            Text("Save")
              .foregroundColor(Color("TextColor"))
          })
      )
      HStack {
        Spacer()
        Button(action: {
          if (!timerIsActive) {
            playActions()
          }
          else {
            stopActions()
          }
        }) {
          Image(systemName: timerIsActive ? "stop.fill" : "play.fill")
            .resizable()
            .frame(width: 20, height: 20)
            .padding()
        }
        .foregroundColor(Color("TextColor"))
        Spacer()
      }
      .alert(isPresented: $isBoilValidationAlertVisible) {
        return Alert(title: Text("Alert"), message: Text("Note - Boil duration must be greater or equal longest hopping duration."), dismissButton: .cancel())
      }
      
      if timerIsActive {
        VStack {
          Text("Boiling started!")
            .padding(.bottom, 5)
            .padding(.top, 10)
          Text("Current time: \(timeString(date: realtimeDateDisplayed))")
            .padding(.bottom, 5)
        }
        HStack {
          Text("Start: \(timeString(date: startDate))")
          Spacer()
          Text("End: \(timeString(date: endDate))")
        }
        .padding(.bottom, 10)
        .onAppear {
          setBoilTimer()
          setImageTimer()
          startDate = Date()
          endDate = SetEndDate(minutes: boilLength)
          hopsWithSetTime = GetHopNameAndTime()
          additionsWithSetTime = GetAdditionNameAndTime()
          combinedHopsAndAdditions = GetAdditionsAndHopsCombined()
        }
        
        HStack {
          Text("Schedule of additions")
            .bold()
          Spacer()
        }
        ScrollView {
          ForEach(Array(combinedHopsAndAdditions), id: \.0) { item in
            HStack {
              Text("Add \(item.0) - \(item.1)\(hopUnit)")
              Spacer()
              Text("@ \(timeString(date: item.2))")
            }
            .onAppear() {
              let delayedDate = Calendar.current.date(byAdding: .second, value: 5, to: item.2)
              notification.AddNotification(title: "Alert (Addition)", body: "Add \(item.0) - \(item.1)\(hopUnit)", exactDate: delayedDate ?? item.2)
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
    .offset(x: 0, y: -40)
  }
}

struct BoilView_Previews: PreviewProvider {
  static var previews: some View {
    BoilView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity())
    BoilView(recipeEntity: PersistenceController.preview.allRecipes.first ?? RecipeEntity()).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
