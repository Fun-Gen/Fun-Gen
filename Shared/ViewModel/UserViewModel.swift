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
                    self.userObserverHandler = self.database
                        .collection("users")
                        .document(newID)
                        .addSnapshotListener { [weak self] snapshot, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            self?.user = try? snapshot?.data(as: User.self)
                        }
                }
            }
        }
    }
    
    // MARK: - Firebase Auth Functions
    
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
    
    // MARK: - Firestore Functions for User Data
    
    private func add(_ user: User) {
        precondition(userIsAuthenticated)
        do {
            try database.collection("users").document(user.id).setData(from: user)
        } catch {
            fatalError("User not encodable")
        }
    }
    
    // MARK: - Operations Specified in Requirements
    
    /// Fetch user with ID once.
    static func user(id: User.ID) -> User? {
        return users(ids: [id]).first?.flatMap { $0 }
    }
    
    /// Fetch users with IDs once.
    static func users(ids: [User.ID]) -> [User?] {
        // FIXME: missing implementation
        return []
    }
    
    /// Fetch Users by username (prefix/full match, maybe fuzzy match for stretch goal) once.
    static func users(named name: String) -> [User] {
        // FIXME: missing implementation
        return []
    }
    
    /// Fetch User by email (match entire email) once.
    static func user(email: String) -> User? {
        // FIXME: missing implementation
        return nil
    }
}
