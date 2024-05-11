//
//  WalkShareApp.swift
//  WalkShare
//
//  Created by 加藤 on 2024/03/27.
//

import SwiftUI
import FirebaseCore
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct WalkShareApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL{ url in
                                    GIDSignIn.sharedInstance.handle(url)
                            }
                .onAppear{
                                    GIDSignIn.sharedInstance.restorePreviousSignIn{ user,error in
                                    }
                        }
        }
    }
}

