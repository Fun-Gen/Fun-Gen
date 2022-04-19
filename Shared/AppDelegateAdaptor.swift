//
//  AppDelegateAdaptor.swift
//  Fun Gen
//
//  Created by jules on 4/16/22.
//

import SwiftUI
import Firebase

class AppDelegateAdaptor: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
                    -> Bool {
        FirebaseApp.configure()
        return true
    }
}
