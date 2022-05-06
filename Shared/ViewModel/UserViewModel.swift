//
//  UserViewModel.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/18/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
    /// The current user logged in, if any
    @Published private(set) var user: User?
    
    private let auth = Auth.auth()
    private static let database = Firestore.firestore()
    private static let usersCollection = "users"
    
    var uuid: String? {
        auth.currentUser?.uid
    }
    var userIsAuthenticated: Bool {
        auth.currentUser != nil
    }
    var userIsAuthenticatedAndSynced: Bool {
        user != nil && userIsAuthenticated
    }
    
    private var userObserverHandler: ListenerRegistration?
    
    init() {
        setupAutoUpdate()
    }
    
    func setupAutoUpdate() {
        auth.addStateDidChangeListener { [weak self] _, authUser in
            guard let self = self else { return }
            if authUser?.uid != self.user?.id {
                self.userObserverHandler?.remove()
                self.userObserverHandler = nil
                if let newID = authUser?.uid {
                    self.userObserverHandler = Self.database
                        .collection(Self.usersCollection)
                        .document(newID)
                        .addSnapshotListener { [weak self] snapshot, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            do {
                                self?.user = try snapshot?.data(as: User.self)
                            } catch {
                                print(error)
                            }
                        }
                }
            }
        }
    }
    
    // MARK: - Firebase Auth Functions
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signUp(email: String, username: String, password: String) async throws {
        let getUser = try await auth.createUser(withEmail: email, password: password).user
        let userID = getUser.uid
        add(User(id: userID, username: username, email: email))
    }
    
    func signOut() throws {
        try auth.signOut()
        user = nil
    }
    
    // MARK: - Firestore Functions for User Data
    
    private func add(_ user: User) {
        precondition(userIsAuthenticated)
        do {
            try Self.database.collection(Self.usersCollection).document(user.id).setData(from: user)
        } catch {
            fatalError("User not encodable")
        }
    }
    
    // MARK: - Operations Specified in Requirements
    
    /// Fetch user with ID once.
    /// - Parameter id: the ID of ``User`` to fetch.
    /// - Returns: the ``User`` with given id if found, or nil otherwise.
    static func user(id: User.ID) async throws -> User? {
        return try await users(ids: [id]).first
    }
    
    /// Fetch users with IDs once.
    /// - Parameter ids: the IDs of users to fetch.
    /// - Returns: the ``User``s matching the given ids in no specific order, and
    /// may contain fewer users than the specified ids if some of the ids cannot be found in the database.
    static func users(ids: [User.ID]) async throws -> [User] {
        return try await database
            .collection(usersCollection)
            .whereField("id", in: ids)
            .getDocuments()
            .documents
            .map { try $0.data(as: User.self) }
    }
    
    /// Fetch Users by username (prefix/full match, maybe fuzzy match for stretch goal) once.
    /// - Note: anything other than full username match (such as prefix or fuzzy match)
    /// requires additional 3rd party dependencies. See Firestore's documentation for more details:
    /// https://firebase.google.com/docs/firestore/solutions/search
    static func user(named name: String) async throws -> User? {
        return try await database
            .collection(usersCollection)
            .whereField("username", isEqualTo: name)
            .getDocuments()
            .documents
            .first
            .map { try $0.data(as: User.self) }
    }
    
    /// Fetch User by email (match entire email) once.
    static func user(email: String) async throws -> User? {
        return try await database
            .collection(usersCollection)
            .whereField("email", isEqualTo: email)
            .getDocuments()
            .documents
            .first
            .map { try $0.data(as: User.self) }
    }
}
