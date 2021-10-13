//
//  BoilNotifications.swift
//  Beeryo
//
//  Created by Jacek K on 13/10/2021.
//

import Foundation
import UserNotifications

class BoilNotifications {
  static let shared = BoilNotifications()
  
  func AddNotification(title: String, body: String, _date: TimeInterval) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = "subtitle"
    content.body =  body
    content.badge = 1
    content.sound = .defaultCritical
    let date = Date().addingTimeInterval(_date)
    let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    center.add(request)
  }
}
