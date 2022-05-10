//
//  ContentView.swift
//  Shared
//
//  Created by Apollo Zhu on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var user: UserViewModel
    var body: some View {
         if user.userIsAuthenticated {
             TabView {
                 HomeView().tabItem {
                     Image(systemName: "house")
                     Text("Home")
                 }
                 ProfileView().tabItem {
                     Image(systemName: "person")
                     Text("Profile")
                 }
             }
         } else {
             NavigationView {
                 AuthenticationView()
             }
         }
    }
}

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
             .environmentObject(UserViewModel())
     }
 }
