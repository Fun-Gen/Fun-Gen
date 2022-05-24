//
//  PollOption.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 4/28/22.
//

import Foundation

/// Keeps tracks of members of an activity who voted on an ``Option`` for a specific ``Activity``.
struct PollOption: Codable, Equatable {
    /// The database id of the ``Option`` been voted on.
    var optionID: Option.ID
    
    /// Original user who added this ``Option`` referenced by ``optionID`` to the current activity.
    var author: User.ID
    
    /// Users who voted on the ``Option`` referenced by ``optionID``.
    var members: [User.ID] = []
    
    /// Sum of votes for this ``Option`` referenced by ``optionID``.
    var voteCount: Int {
        members.count
    }
}
