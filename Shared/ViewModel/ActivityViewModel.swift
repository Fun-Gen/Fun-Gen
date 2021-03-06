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
    
    @Published private(set) var activity: Activity?
    private var listenerRegistration: ListenerRegistration?
    
    /// A publisher for getting the latest values of an activity specified by the activityID.
    init(activityID: Activity.ID) {
        listenerRegistration = Self.database
            .collection(Self.activitiesCollection)
            .document(activityID)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    // TODO: surface error
                    print(error)
                    return
                }
                do {
                    self?.activity = try snapshot?.data(as: Activity.self)
                } catch {
                    // TODO: surface error
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
        optionTitles: [String],
        additionalMembers: [User.ID]
    ) async throws -> Activity.ID {
        assert(!additionalMembers.contains(author))
        let allMembers = additionalMembers + [author]
        let activityRef = database.collection(activitiesCollection).document()
        let activityID = activityRef.documentID
        let options = try await OptionViewModel.createOptions(titles: optionTitles)
        let voteCount = 0
        let batch = database.batch()
        try batch.setData(from: Activity(
            id: activityID,
            title: title,
            category: category,
            author: author,
            members: allMembers,
            options: Dictionary(uniqueKeysWithValues: options.map {
                ($0, PollOption(optionID: $0, author: author, voteCount: voteCount))
            }),
            voteCount: voteCount
        ), forDocument: activityRef)
        
        for member in allMembers {
            let userRef = database
                .collection(UserViewModel.usersCollection)
                .document(member)
            batch.updateData([
                "activities": FieldValue.arrayUnion([activityID])
            ], forDocument: userRef)
        }
        
        try await batch.commit()
        
        return activityID
    }
    
    static func deleteActivity(_ activityID: Activity.ID) async throws {
        let activityRef = database.collection(activitiesCollection).document(activityID)
        try await database.runTransaction { transaction, errorPointer -> Void in
            do {
                let snapshot = try transaction.getDocument(activityRef)
                let activity = try snapshot.data(as: Activity.self)
                // Remove all options
                for optionID in activity.options.keys {
                    let optionRef = database
                        .collection(OptionViewModel.optionsCollection)
                        .document(optionID)
                    transaction.deleteDocument(optionRef)
                }
                // Remove activity from user
                for member in activity.members {
                    let userRef = database
                        .collection(UserViewModel.usersCollection)
                        .document(member)
                    transaction.updateData([
                        "activities": FieldValue.arrayRemove([activityID])
                    ], forDocument: userRef)
                }
                // Remove activity
                transaction.deleteDocument(activityRef)
            } catch {
                errorPointer?.pointee = error as NSError
            }
        }
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
        var activityUpdates: [FieldPath: Any] = [:]
        if let currentOptionID = currentOptionID {
            optionUpdates[FieldPath(["options", currentOptionID, "members"])]
            = FieldValue.arrayRemove([userID])
            
            optionUpdates[FieldPath(["options", currentOptionID, "voteCount"])]
            = FieldValue.increment(Int64(-1))
            
            activityUpdates[FieldPath(["voteCount"])]
            = FieldValue.increment(Int64(-1))
        }
        try await database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData(activityUpdates)
        if let newOptionID = newOptionID {
            optionUpdates[FieldPath(["options", newOptionID, "members"])]
            = FieldValue.arrayUnion([userID])
            
            optionUpdates[FieldPath(["options", newOptionID, "voteCount"])]
            = FieldValue.increment(Int64(1))
            
            activityUpdates[FieldPath(["voteCount"])]
            = FieldValue.increment(Int64(1))
        }
        try await database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData(optionUpdates)
        try await database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData(activityUpdates)
    }
    
    /// A function that determines the winning ``Option`` in an ``Activity``.
    /// If all members in an ``Activity`` have not voted, an error will be thrown.
    /// Ties are broken by randomly selecting from a list of ``Option``s that are tied with the highest vote count.
    /// Winning ``Option`` is stored in ``selectedOption`` in the ``Activity`` and returned.
    static func endVote(forActivity activityID: Activity.ID) async throws -> Option.ID {
        var max: Int = 0
        var tie: [PollOption] = []
        var winner: Option.ID = ""

        // Get the snapshot of current activity
        let snapshot = try await activity(id: activityID)
        let activityVoteCount = snapshot.voteCount
        let activityMembers = snapshot.members.count
        
        // Handle an incomplete voting round
        if activityVoteCount < activityMembers {
            throw FunGenError.activityDoesNotHaveAllVotesIn
        }
        
        // Find Option with highest vote
        // Track all Options that are tied
        for option in snapshot.options.values {
            if option.members.count > max {
                max = option.members.count
                winner = option.optionID
                tie.removeAll()
                tie.append(option)
            } else if option.members.count == max {
                winner = ""
                tie.append(option)
            }
        }

        // Tie breaker to select random Option among ties
        if tie.count > 1 {
            guard let tie = tie.randomElement()?.optionID else {
                throw FunGenError.activityNoLongerContainsThisOption
            }
            winner = tie
        }
        
        // Update selectedOption field in database with the winner
        try await database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData([
                FieldPath(["selectedOption"]): winner
            ])
        return winner
    }
    
    /// Add an ``Option`` specified by its ID to activity.options
    /// - Precondition: the given `optionID` points to a valid option.
    static func addOption(title: String,
                          byUser userID: User.ID,
                          toActivity activityID: Activity.ID
    ) async throws -> Option.ID {
        let optionID = try await OptionViewModel.createOption(title: title)
        let voteCount = 0
        let newPollOption = try Firestore.Encoder()
            .encode(PollOption(optionID: optionID, author: userID, voteCount: voteCount))
        try await database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData([
                FieldPath(["options", optionID]): newPollOption
            ])
        return optionID
    }
    
    static func removeOption(_ optionID: Option.ID,
                             fromActivity activityID: Activity.ID) async throws {
        try await database
            .collection(activitiesCollection)
            .document(activityID)
            .updateData([
                FieldPath(["options", optionID]): FieldValue.delete()
            ])
    }
    
    // TODO: add implementation for Add UserID to Activity.members for stretch goal
    
    /// Randomly pick the Activity.selectedOption from all the option
    static func selectRandomOption(
        forActivity activityID: Activity.ID
    ) async throws -> Option.ID {
        let activityRef = database.collection(activitiesCollection).document(activityID)
        return try await database.runTransaction { transaction, errorPointer -> Option.ID? in
            do {
                let snapshot = try transaction.getDocument(activityRef)
                let activity = try snapshot.data(as: Activity.self)
                guard let optionID = activity.options.keys.randomElement() else {
                    throw FunGenError.activityHasNoOptionForRandomSelection
                }
                transaction.updateData([
                    "selectedOption": optionID
                ], forDocument: activityRef)
                return optionID
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
        } as! Option.ID // swiftlint:disable:this force_cast
        // we know this can only return Option.ID
    }
    
    /// This is undemocratic and should not be called by client code
    static func _vetoSelectedOption( // swiftlint:disable:this identifier_name
        forActivity activityID: Activity.ID
    ) async throws {
        let activityRef = database.collection(activitiesCollection).document(activityID)
        try await database.runTransaction { transaction, _ in
            transaction.updateData([
                "selectedOption": FieldValue.delete()
            ], forDocument: activityRef)
        }
    }
}
