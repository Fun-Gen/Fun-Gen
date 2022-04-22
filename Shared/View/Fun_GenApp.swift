//
//  Fun_GenApp.swift
//  Shared
//
//  Created by Apollo Zhu on 4/14/22.
//

import SwiftUI
import UIKit
import Firebase

@main
struct Fun_GenApp: App {
    // firebase init
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserViewModel())
        }
    }
}

// firebase init
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
