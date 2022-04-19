//
//  User.swift
//  Fun Gen
//
//  Created by jules on 4/18/22.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    var signUpDate = Date.now
}
