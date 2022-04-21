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
        NavigationView {
            if user.userIsAuthenticated {
                ProfileView()
            } else {
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
