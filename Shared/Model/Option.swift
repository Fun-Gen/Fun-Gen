//
//  Option.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/23/22.
//

import Foundation

struct Option: Codable {
    var title: String
    var author: String
    var members: [User] = []
    var voteCount: Int
}
