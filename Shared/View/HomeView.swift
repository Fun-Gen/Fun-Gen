//
//  HomeView.swift
//  Fun Gen
//
//  Created by Finnigan Johnson on 4/25/22.
//

import SwiftUI

struct HomeView: View {
//    @EnvironmentObject var activityStore: ActivityStore
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if let user = userViewModel.user {
                    List {
                        ForEach(user.activities, id: \.self) { activityID in
                            NavigationLink {
                                VoteView()
                                    .environmentObject(ActivityViewModel(activityID: activityID))
                            } label: {
                                HomeActivityCard(activityViewModel: ActivityViewModel(activityID: activityID))
                            }
                        }
                    }
                } else {
                    Text("Loading...")
                }
            }
            .navigationTitle("FunGen")
            .toolbar {
                NavigationLink(destination: CreateActivityView(), label: {
                    Image(systemName: "plus")
                })
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
        }
    }
}
