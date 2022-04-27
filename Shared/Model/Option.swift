//
//  Option.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/23/22.
//

import Foundation

/// An **Option** is what a **User** suggests for the **Activity** which will be voted on or randomly selected
///
/// Stores reference to all **Users** who vote for this **Option**
struct Option: Codable {
    /// Unique database ID
    var id: String
    
    /// Entered during **Option** creation
    var title: String
    
    /// *User.id*
    var author: String
    
    /// Array of *User.id*
    var members: [String] = []
    
    /// Sum of votes for this **Option**
    var voteCount: Int
}
