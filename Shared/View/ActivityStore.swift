//
//  ActivityStore.swift
//  Fun Gen
//
//  Created by Finnigan Johnson on 5/9/22.
//

import Foundation

class ActivityStore: ObservableObject {
    @Published var activities: [Activity]
    
    init(activities: [Activity] = []) {
        self.activities = activities
    }
}

let testActivityStore = ActivityStore(activities: testActivities)
