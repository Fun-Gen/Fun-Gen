//
//  Activity.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/23/22.
//

import Foundation

struct Activity: Codable {
    var id: String
    var title: String
    var category: Category
    var author: User
    var members: [User] = []
    var options: [Option] = []
    var voteCount: Int
}
