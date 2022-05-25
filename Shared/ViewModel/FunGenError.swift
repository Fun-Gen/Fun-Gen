//
//  FunGenError.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/3/22.
//

import Foundation

enum FunGenError: LocalizedError {
    case activityHasNoOptionForRandomSelection
    case activityAlreadyHasSelectedOption
    case activityNotFound
    
    var errorDescription: String? {
        switch self {
        case .activityAlreadyHasSelectedOption:
            return "The activity already has a selected option."
        case .activityHasNoOptionForRandomSelection:
            return "The activity has no option to randomly select from."
        case .activityNotFound:
            return "Activity not found."
        }
    }
}
