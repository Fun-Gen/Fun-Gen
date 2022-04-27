//
//  User.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/18/22.
//

import Foundation

/// Stores information to identify the **User** and each **Activity** they are subscribed to
struct User: Codable {
    /// Unique database ID
    var id: String
    
    /// Entered during **User** signup
    var username: String
    var email: String
    
    /// Array of *Activity.id*
    var activities: [String] = []
}
