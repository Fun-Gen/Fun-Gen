//
//  VoteOptionView.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/9/22.
//

import SwiftUI

struct VoteOptionView: View {
    var select: (Option.ID) async -> Void
    @EnvironmentObject var userViewModel: UserViewModel
    let optionID: Option.ID
    let activity: Activity
    @StateObject var optionViewModel: OptionViewModel
    
    var isSelected: Bool {
        if let currentUserID = userViewModel.user?.id,
           let options = activity.options[optionID] {
            return options.members.contains(currentUserID)
        } else {
            return false
        }
    }
    
    var body: some View {
        // FIXME: seems that not the entire button is clickable
        Button {
            Task {
                guard let userID = userViewModel.user?.id else {
                    print("Missing user id")
                    return
                }
                await select(optionID)
            }
        } label: {
            if let option = optionViewModel.option {
                Text(option.title)
            } else {
                Text("Loading...")
            }
        }
        .font(.body)
        .padding(4)
        .padding(.trailing, 200)
        .background(isSelected ? Color.yellow : Color.white)
        .cornerRadius(16)
    }
}

// struct VoteOptionView_Previews: PreviewProvider {
//     static var previews: some View {
//         VoteOptionView(optionID: <#Option.ID#>, activity: <#Activity#>, optionViewModel: <#OptionViewModel#>)
//     }
// }
