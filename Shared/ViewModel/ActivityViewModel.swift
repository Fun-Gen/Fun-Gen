//
//  ActivityViewModel.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/3/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import CodableFirebase
import Combine

class ActivityViewModel: ObservableObject {
    private let firestore = Firestore.firestore()
    private let activitiesCollection = "activities"
    
    // Create an Activity.
    // TODO: confirm parameters
    func createActivity() -> Activity.ID {
        // FIXME: missing implementation
        return ""
    }
    
    /// A publisher for getting the latest values of an activity specified by the activityID.
    func activityPublisher(actvityID: Activity.ID) -> AnyPublisher<Activity, Error> {
        firestore
            .collection(activitiesCollection)
            .document(actvityID)
            .snapshotPublisher()
            .compactMap { $0.data() }
            .tryMap { try FirebaseDecoder().decode(Activity.self, from: $0) }
            .eraseToAnyPublisher()
    }
    
    // Get activity specified by ID once.
    func activity(id: Activity.ID) async throws -> Activity {
        let snapshot = try await firestore
            .collection(activitiesCollection)
            .document(id)
            .getDocument()
        guard let data = snapshot.data() else {
            throw FunGenError.missingSnapshotData
        }
        return try FirebaseDecoder().decode(Activity.self, from: data)
    }
    
    // TODO: add implementation for:
    //    Add UserID to Activity.members
    //    Add an Option to Activity.options
    //    Add member UserID to an option in Activity.options (vote)
    //    Randomly pick the Activity.selectedOption from
    //    All the option
    //    The top voted option
    //    Get the list of Options with the most members
}
