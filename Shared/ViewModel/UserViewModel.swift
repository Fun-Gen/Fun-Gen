//
//  UserViewModel.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/18/22.
//

import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import CodableFirebase

class UserViewModel: ObservableObject {
    /// The current user logged in, if any
    @Published var user: User?
    
    private let auth = Auth.auth()
    private let database = Firestore.firestore()
    var uuid: String? {
        auth.currentUser?.uid
    }
    var userIsAuthenticated: Bool {
        auth.currentUser != nil
    }
    var userIsAuthenticatedAndSynced: Bool {
        user != nil && userIsAuthenticated
    }
    
    private var userObserverHandler: AnyCancellable?
    
    init() {
        setupAutoUpdate()
    }
    
    func setupAutoUpdate() {
        auth.addStateDidChangeListener { [weak self] _, authUser in
            guard let self = self else { return }
            if authUser?.uid != self.user?.id {
                self.userObserverHandler?.cancel()
                self.userObserverHandler = nil
                if let newID = authUser?.uid {
                    self.userObserverHandler = self.database
                        .collection("users")
                        .document(newID)
                        .snapshotPublisher()
                        .compactMap { $0.data() }
                        .tryMap { try FirebaseDecoder().decode(User.self, from: $0) }
                        .sink { _ in
                            // ignore completion
                        } receiveValue: { user in
                            self.user = user
                        }
                }
            }
        }
    }
    
    // Firebase Auth Functions
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
        }
    }
    
    func signUp(email: String, username: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            // constants for retrieving newly generated Firebase user ID
            let getUser = Auth.auth().currentUser
            let userID: String = getUser?.uid ?? ""
            DispatchQueue.main.async {
                self?.add(User(id: userID, username: username, email: email))
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            user = nil
        } catch {
            print("Error signing out user: \(error)")
        }
    }
    
    // Firestore Functions for User Data
    
    private func add(_ user: User) {
        guard userIsAuthenticated, let uuid = uuid else { return }
        do {
            let _: Void = try database.collection("users").document(uuid).setData(from: user)
        } catch {
            print("Error adding: \(error)")
        }
    }
    
    private func update() {
        guard userIsAuthenticatedAndSynced, let uuid = uuid else { return }
        do {
            let _: Void = try database.collection("users").document(uuid).setData(from: user)
        } catch {
            print("Error updating: \(error)")
        }
    }
    
    // MARK: - Operations Speecified in Requirements
    
    /// Fetch user with ID.
    func user(id: User.ID) -> User? {
        return users(ids: [id]).first?.flatMap { $0 }
    }
    
    /// Fetch users with IDs.
    func users(ids: [User.ID]) -> [User?] {
        // FIXME: missing implementation
        return []
    }
    
    /// Fetch Users by username (prefix/full match, maybe fuzzy match for stretch goal).
    func users(named name: String) -> [User] {
        // FIXME: missing implementation
        return []
    }
    
    /// Fetch User by email (match entire email).
    func user(email: String) -> User? {
        // FIXME: missing implementation
        return nil
    }
}
