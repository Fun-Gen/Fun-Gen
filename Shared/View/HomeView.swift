//
//  HomeView.swift
//  Fun Gen
//
//  Created by Finnigan Johnson on 4/25/22.
//

import SwiftUI

struct HomeView: View {
    var activities: [Activity] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(activities) { activity in
                    NavigationLink(destination: Text(activity.title)) {
                        Text(activity.title)
                    }
                }
            }
            .navigationTitle("FunGen")
            .toolbar {
                Button(action: {
                    print("hi")
                }, label: {
                    Image(systemName: "plus")
                })
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
