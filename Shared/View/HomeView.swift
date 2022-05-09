//
//  HomeView.swift
//  Fun Gen
//
//  Created by Finnigan Johnson on 4/25/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var activityStore: ActivityStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(activityStore.activities) { activity in
                    NavigationLink(destination: VoteView(activity: activity)) {
                        Text(activity.title)
                    }
                }
            }
            .navigationTitle("FunGen")
            .toolbar {
                NavigationLink(destination: CreateActivityView(activityStore: activityStore), label: {
                    Image(systemName: "plus")
                })
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(activityStore: testActivityStore)
        }
    }
}
