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
    
    /// FIXME: Make this a tuple of (Option.ID, [User.ID])
    /// Contains all ``Option``s suggested by ``members``
    var options: [Option.ID] = []
    
    /// Sum of votes for this ``Activity``
    var voteCount: Int
}
