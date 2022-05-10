//
//  VoteOptionView.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/9/22.
//

import SwiftUI

struct VoteOptionView: View {
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
                    // TODO: handle error
                    print("Missing user id")
                    return
                }
                do {
                    try await ActivityViewModel
                        .changeVote(ofUser: userID,
                                    addTo: optionID,
                                    inActivity: activity.id)
                } catch {
                    // TODO: handle error
                    print(error)
                }
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

//struct VoteOptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        VoteOptionView(optionID: <#Option.ID#>, activity: <#Activity#>, optionViewModel: <#OptionViewModel#>)
//    }
//}
