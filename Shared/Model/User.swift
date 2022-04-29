//
//  User.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/18/22.
//

import Foundation

/// Stores information to identify the ``User`` and references each ``Activity`` they are subscribed to
struct User: Codable, Identifiable {
    typealias ID = String
    
    /// Unique database ID
    var id: ID
    
    /// Entered during ``User`` signup
    var username: String
    var email: String
    
    /// Contains all ``Activity`` a ``User`` is participating in
    var activities: [Activity.ID] = []
}
