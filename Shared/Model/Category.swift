//
//  Category.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/23/22.
//

import Foundation

/// Broadly categorizes an ``Activity`` for future Fun Gen features (e.g. recently used ``Option``s)
enum Category: String, Codable, CaseIterable {
    case outdoor
    case game
    case destination
    case movie
    case tvShow
    case food
    case drinking
    case shopping
}
