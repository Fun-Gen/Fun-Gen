//
//  OptionViewModel.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/5/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum OptionViewModel {
    static let database = Firestore.firestore()
    static let optionsCollection = "options"
    static func create(title: String) -> Option.ID {
        let ref = database.collection(optionsCollection).document()
        let optionID = ref.documentID
        do {
            try ref.setData(from: Option(id: optionID, title: title))
        } catch {
            fatalError("Option not encodable")
        }
        return ref.documentID
    }
}
