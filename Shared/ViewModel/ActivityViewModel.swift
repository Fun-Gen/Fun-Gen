//
//  ActivityViewModel.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/3/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ActivityViewModel: ObservableObject {
    private static let database = Firestore.firestore()
    static let activitiesCollection = "activities"
    
    let activityID: Activity.ID
    @Published private(set) var activity: Activity?
    
    private var activityObservation: ListenerRegistration?
    
    /// A publisher for getting the latest values of an activity specified by the activityID.
    init(activityID: Activity.ID) {
        self.activityID = activityID
        activityObservation = Self.database
            .collection(Self.activitiesCollection)
            .document(activityID)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                do {
                    self?.activity = try snapshot?.data(as: Activity.self)
                } catch {
                    print(error)
                }
            }
    }
    
    // MARK: - Static Helpers
    
    // Create an Activity.
    static func createActivity(
        title: String,
        category: Category,
        author: User.ID,
        options: [Option.ID],
        additionalMembers: [User.ID]
    ) -> Activity.ID {
        assert(!additionalMembers.contains(author))
        let allMembers = additionalMembers + [author]
        let ref = database.collection(activitiesCollection).document()
        let activityID = ref.documentID
        do {
            try ref.setData(from: Activity(
                id: activityID,
                title: title,
                category: category,
                author: author,
                members: allMembers,
                options: Dictionary(uniqueKeysWithValues: options.map {
                    ($0, PollOption(optionID: $0, author: author))
                })
            ))
        } catch {
            fatalError("Activity not encodable")
        }
        for member in allMembers {
            UserViewModel._addActivity(id: activityID, toUser: member)
        }
        return activityID
    }
    
    // Get activity specified by ID **once**.
    static func activity(id: Activity.ID) async throws -> Activity {
        return try await database
            .collection(activitiesCollection)
            .document(id)
            .getDocument(as: Activity.self)
    }
    
    static func changeVote(ofUser userID: User.ID,
                           removeFrom currentOptionID: Option.ID? = nil,
                           addTo newOptionID: Option.ID? = nil,
                           inActivity activityID: Activity.ID) async throws {
        precondition(currentOptionID != nil || newOptionID != nil,
                     "Must at least specify either an ID to remove or add vote to")
        var optionUpdates: [FieldPath: Any] = [:]
        if let currentOptionID = currentOptionID {
            optionUpdates[FieldPath(["options", currentOptionID, "members"])]
            = FieldValue.arrayRemove([userID])
        }
        if let newOptionID = newOptionID {
            optionUpdates[FieldPath(["options", newOptionID, "members"])]
            = FieldValue.arrayUnion([userID])
        }
        try await database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData(optionUpdates)
    }
    
    /// Add an ``Option`` specified by its ID to activity.options
    /// - Precondition: the given `optionID` points to a valid option.
    static func addOption(_ optionID: Option.ID,
                          byUser userID: User.ID,
                          toActivity activityID: Activity.ID) {
        let newPollOption: [String: Any]
        do {
            newPollOption = try Firestore.Encoder()
                .encode(PollOption(optionID: optionID, author: userID))
        } catch {
            fatalError("PollOption not encodable")
        }
        database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData([
                FieldPath(["options", optionID]): newPollOption
            ])
    }
    
    static func removeOption(_ optionID: Option.ID,
                             fromActivity activityID: Activity.ID) {
        database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData([
                FieldPath(["options", optionID]): FieldValue.delete()
            ])
    }
    
    // TODO: add implementation for:
    //    Add UserID to Activity.members
    //    Randomly pick the Activity.selectedOption from all the option
    //    The top voted option
    //    Get the list of Options with the most members
}
