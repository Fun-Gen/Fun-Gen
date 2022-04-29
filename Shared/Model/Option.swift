//
//  Option.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/23/22.
//

import Foundation

/// An ``Option`` is what a ``User`` suggests for the ``Activity`` which will be voted on or randomly selected
///
/// Stores reference to all ``User``s who vote for this ``Option``
struct Option: Codable, Identifiable {
    typealias ID = String
    
    /// Unique database ID
    var id: ID
    
    /// Entered during ``Option`` creation
    var title: String
}
