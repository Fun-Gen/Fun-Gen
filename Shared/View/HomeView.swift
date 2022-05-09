//
//  HomeView.swift
//  Fun Gen
//
//  Created by Finnigan Johnson on 4/25/22.
//

import SwiftUI

struct HomeView: View {
    var activities: [Activity] = []
    
    // TODO: needs to loop through the var activities: [Activity.ID] = [] from the User
    var body: some View {
        List {
            ForEach(activities) { activity in
                NavigationLink(destination: Text(activity.title)) {
                    Text(activity.title)
                }
            }
        }
        .navigationTitle("FunGen")
        .toolbar {
            NavigationLink(destination: CreateActivityView()) {
                Image(systemName: "plus")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(activities: testActivities)
        }
    }
}
