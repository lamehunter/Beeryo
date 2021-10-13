////
////  HopTimeManager.swift
////  Beeryo
////
////  Created by Jacek K on 12/10/2021.
////
//
//import Foundation
//
//class HopTimeManager: ObservableObject {
//  @Published var hopNameAndDate: [(String, Date)] = []
//  var recipeEntity: RecipeEntity
//  var beginDate: Date
//  var boilDurationMinutes: Int
//  var boilDurationSeconds: Int {
//    return boilDurationMinutes * 60
//  }
//
//  init(recipe: RecipeEntity, beginDate: Date, boilDurationMinutes: Int) {
//    self.recipeEntity = recipe
//    self.beginDate = beginDate
//    self.boilDurationMinutes = boilDurationMinutes
//    startTimer()
//  }
//
//  var timer = Timer()
//
//  func startTimer() {
//    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//  }
//
//  func endTimer() {
//    timer.invalidate()
//  }
//
//  @objc func updateTime() {
//    print(timeFormatted(boilDurationSeconds))
//
//    if boilDurationSeconds != 0 {
//      boilDurationSeconds -= 1
//    } else {
//      endTimer()
//    }
//  }
//
//  func timeFormatted(_ totalSeconds: Int) -> String {
//    let seconds: Int = totalSeconds % 60
//    let minutes: Int = (totalSeconds / 60) % 60
//    let hours: Int = totalSeconds / 3600
//    return String(format: "%02d:%02d", minutes, seconds)
//  }
//
//  var timeFormat: DateFormatter {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "hh:mm:ss a"
//    return formatter
//  }
//
//  func timeString(date: Date) -> String {
//    let time = timeFormat.string(from: date)
//    return time
//  }
//
//  func GetHopsNameAndDurationPairSorted() -> [(String, Date)] {
//    var array: [(String, Date)] = []
//
//    if let hopEntities = recipeEntity.hops?.allObjects as? [HopsEntity] {
//      for hop in hopEntities.sorted(by: {$0.duration > $1.duration}) {
//        let hopEndDate: Date = SetEndDate(minutes: String(hop.duration))
//        array.append((hop.name ?? "", hopEndDate))
//      }
//    }
//    return array
//  }
//
//
//
//  func SetEndDate(minutes: String) -> Date {
//    let minutesInt: Int = Int(minutes) ?? 0
//    let endDate = Calendar.current.date(byAdding: DateComponents(minute: minutesInt), to: startDate)
//    return endDate!
//  }
//
//}
