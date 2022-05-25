//
//  HomeView.swift
//  Fun Gen
//
//  Created by Finnigan Johnson on 4/25/22.
//

import SwiftUI

struct HomeView: View {
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
                                    .environmentObject(UserViewModel())
                            } label: {
                                HomeActivityCard(activityViewModel: ActivityViewModel(activityID: activityID))
                            }
                        }
                        .onDelete { indexSet in
                            let activityIDs = indexSet.map { user.activities[$0] }
                            for activityID in activityIDs {
                                Task {
                                    do {
                                        try await ActivityViewModel.deleteActivity(activityID)
                                    } catch FunGenError.activityNotFound {
                                        try await UserViewModel
                                            ._removeNonExistentActivity(activityID, fromUser: user.id)
                                    } catch {
                                        // TODO: handle (potentially sequence of) error
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("Loading...")
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView().environmentObject(UserViewModel())
        }
    }
}
