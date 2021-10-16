//
//  BoilNotifications.swift
//  Beeryo
//
//  Created by Jacek K on 13/10/2021.
//

import Foundation
import UserNotifications

class Notification {
  static let shared = Notification()
  
  func AddNotification(title: String, body: String, afterTimeIntervalOf: TimeInterval) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.body =  body
    //content.badge = 1
    content.sound = .defaultCritical
    let date = Date().addingTimeInterval(afterTimeIntervalOf)
    let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    center.add(request)
  }
  
  func AddNotification(title: String, body: String, exactDate: Date) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.body =  body
    //content.badge = 1
    content.sound = .defaultCritical
    let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: exactDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    center.add(request)
  }
  
  func RemoveAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}
