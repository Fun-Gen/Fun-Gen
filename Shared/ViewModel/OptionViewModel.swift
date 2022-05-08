//
//  OptionViewModel.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/5/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class OptionViewModel: ObservableObject {
    static let database = Firestore.firestore()
    static let optionsCollection = "options"
    
    @Published private(set) var option: Option?
    private var listenerRegistration: ListenerRegistration?
    
    init(optionID: String) {
        listenerRegistration = Self.database
            .collection(Self.optionsCollection)
            .document(optionID)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                do {
                    self?.option = try snapshot?.data(as: Option.self)
                } catch {
                    print(error)
                }
            }
    }
    
    /// Create a new ``Option`` in the database.
    /// - Parameter title: the content of the ``Option`` to create.
    /// - Returns: the ID of the newly created ``Option``.
    static func createOption(title: String) throws -> Option.ID {
        return try createOptions(titles: [title])[0]
    }
    
    /// Create new ``Option``s in the database.
    /// - Parameter titles: the contents of the ``Option``s to create.
    /// - Returns: the IDs of the newly created ``Option``s in the original order.
    static func createOptions(titles: [String]) throws -> [Option.ID] {
        var ids: [Option.ID] = []
        ids.reserveCapacity(titles.count)
        // TODO: batch write for better performance
        for title in titles {
            let ref = database.collection(optionsCollection).document()
            let optionID = ref.documentID
            ids.append(optionID)
            try ref.setData(from: Option(id: optionID, title: title))
        }
        return ids
    }
    
    /// Fetch option with ID once.
    /// - Parameter id: the ID of ``Option`` to fetch.
    /// - Returns: the ``Option`` with given id if found, or nil otherwise.
    static func option(id: Option.ID) async throws -> Option? {
        return try await options(ids: [id]).first
    }
    
    /// Fetch options with IDs once.
    /// - Parameter ids: the IDs of ``Option``s to fetch.
    /// - Returns: the ``Option``s matching the given ids in no specific order, and
    /// may contain fewer options than the specified ids if some of the ids cannot be found in the database.
    static func options(ids: [Option.ID]) async throws -> [Option] {
        return try await database
            .collection(optionsCollection)
            .whereField("id", in: ids)
            .getDocuments()
            .documents
            .map { try $0.data(as: Option.self) }
    }
}
