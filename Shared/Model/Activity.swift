//
//  Activity.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/23/22.
//

import Foundation

/// An ``Activity`` is the overall event that a ``User`` can suggest an ``Option`` for.
///
/// Stores references to all ``Option``s and ``User``s for this ``Activity``
struct Activity: Codable, Identifiable {
    typealias ID = String
    
    /// Unique database ID
    var id: ID
    
    /// Entered during ``Activity`` creation
    var title: String
    var category: Category
    
    /// Original creator of this ``Activity``
    var author: User.ID
    
    /// Contains all ``User``s that are participating in this ``Activity``
    var members: [User.ID] = []
    
    /// Contains all ``PollOption``s suggested by ``members``
    var options: [PollOption] = []
    
    /// Sum of votes for this ``Activity``
    var voteCount: Int
}

let testActivities = [
    Activity(id: "1", title: "Movie", category: Category.movie, author: "1", voteCount: 1),
    Activity(id: "2", title: "Outdoors", category: Category.outdoor, author: "1", voteCount: 1),
    Activity(id: "3", title: "Food", category: Category.food, author: "1", voteCount: 1)
]
