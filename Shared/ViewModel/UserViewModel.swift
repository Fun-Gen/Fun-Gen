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
    
    // Firebase Auth Functions
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.sync()
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
                self?.sync()
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
    // FIXME: try using snapshot listener instead of calling sync function
    private func sync() {
        guard userIsAuthenticated, let uuid = uuid else { return }
        database.collection("users").document(uuid).getDocument { document, error in
            guard let document = document, error == nil else { return }
            do {
                try self.user = document.data(as: User.self)
            } catch {
                print("Sync error: \(error)")
            }
        }
    }
    
    private func add(_ user: User) {
        guard userIsAuthenticated, let uuid = uuid else { return }
        do {
            try database.collection("users").document(uuid).setData(from: user)
        } catch {
            print("Error adding: \(error)")
        }
    }
    
    private func update() {
        guard userIsAuthenticatedAndSynced, let uuid = uuid else { return }
        do {
            try database.collection("users").document(uuid).setData(from: user)
        } catch {
            print("Error updating: \(error)")
        }
    }
}
