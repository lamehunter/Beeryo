//
//  BeeryoApp.swift
//  Beeryo
//
//  Created by Jacek K on 29/08/2021.
//

import SwiftUI
import Combine

@main
struct BeeryoApp: App {
  
  // Block [1] of code used to handle exit of keyboard with no-return button
  @State private var keyboardIsShown = false
  @State private var keyboardHideMonitor: AnyCancellable? = nil
  @State private var keyboardShownMonitor: AnyCancellable? = nil
  
  func setupKeyboardMonitors() {
    keyboardShownMonitor = NotificationCenter.default
      .publisher(for: UIWindow.keyboardWillShowNotification)
      .sink { _ in if !keyboardIsShown { keyboardIsShown = true } }
    
    keyboardHideMonitor = NotificationCenter.default
      .publisher(for: UIWindow.keyboardWillHideNotification)
      .sink { _ in if keyboardIsShown { keyboardIsShown = false } }
  }
  
  func dismantleKeyboarMonitors() {
    keyboardHideMonitor?.cancel()
    keyboardShownMonitor?.cancel()
  }
  // End of Block [1]
  
  
  //line needed for foreground notifications
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  let persistenceContainer = PersistenceController.shared
  //let notification = Notification.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
      .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
      .environment(\.keyboardIsShown, keyboardIsShown)
      .onDisappear { dismantleKeyboarMonitors() }
      .onAppear { setupKeyboardMonitors() }
      
    }
  }
  
}

extension EnvironmentValues {
    var keyboardIsShown: Bool {
        get { return self[KeyboardIsShownEVK] }
        set { self[KeyboardIsShownEVK] = newValue }
    }
}

private struct KeyboardIsShownEVK: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct HideKeyboardGestureModifier: ViewModifier {
    @Environment(\.keyboardIsShown) var keyboardIsShown
    
    func body(content: Content) -> some View {
        content
            .gesture(TapGesture().onEnded {
                UIApplication.shared.resignCurrentResponder()
            }, including: keyboardIsShown ? .all : .none)
    }
}

extension UIApplication {
    func resignCurrentResponder() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}

extension View {

    /// Assigns a tap gesture that dismisses the first responder only when the keyboard is visible to the KeyboardIsShown EnvironmentKey
    func dismissKeyboardOnTap() -> some View {
        modifier(HideKeyboardGestureModifier())
    }
    
    /// Shortcut to close in a function call
    func resignCurrentResponder() {
        UIApplication.shared.resignCurrentResponder()
    }
}



