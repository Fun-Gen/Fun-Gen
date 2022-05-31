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
    case activityNoLongerContainsThisOption
    case activityDoesNotHaveAllVotesIn
    
    var errorDescription: String? {
        switch self {
        case .activityAlreadyHasSelectedOption:
            return "The activity already has a selected option."
        case .activityHasNoOptionForRandomSelection:
            return "The activity has no option to randomly select from."
        case .activityNoLongerContainsThisOption:
            return "The Fun Gen'd option is no longer apart of this Activity."
        case .activityDoesNotHaveAllVotesIn:
            return "There are still members who have not voted."
        }
    }
}
