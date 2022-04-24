//
//  User.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/18/22.
//

import Foundation

struct User: Codable {
    var id: String
    var username: String
    var email: String
    var activities: [Activity] = []
}
