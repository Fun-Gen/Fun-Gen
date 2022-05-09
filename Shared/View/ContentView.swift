//
//  ContentView.swift
//  Shared
//
//  Created by Apollo Zhu on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var user: UserViewModel
    @ObservedObject var activityStore: ActivityStore
    var body: some View {
        HomeView(activityStore: activityStore)
    }
}

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView(activityStore: testActivityStore)
             .environmentObject(UserViewModel())
     }
 }
