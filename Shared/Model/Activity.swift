//
//  Activity.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/23/22.
//

import Foundation

/// An **Activity** is the overall event that a **User** can suggest an **Option** for
///
/// Stores references to all **Options** and **Users** for this **Activity**
struct Activity: Codable {
    /// Unique database ID
    var id: String
    
    /// Entered during **Activity** creation
    var title: String
    var category: Category
    
    /// *User.id*
    var author: String
    
    /// Array of *User.id*
    var members: [String] = []
    
    /// Array of *Option.id*
    var options: [String] = []
    
    /// Sum of votes for this **Activity**
    var voteCount: Int
}
