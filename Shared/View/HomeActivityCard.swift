//
//  HomeActivityCard.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/9/22.
//

import SwiftUI

struct HomeActivityCard: View {
    @ObservedObject var activityViewModel: ActivityViewModel
    
    var body: some View {
        if let activity = activityViewModel.activity {
            Text(activity.title)
        } else {
            Text("Loading...")
        }
    }
}
