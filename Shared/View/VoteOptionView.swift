//
//  VoteOptionView.swift
//  Fun Gen
//
//  Created by Apollo Zhu on 5/9/22.
//

import SwiftUI

struct VoteOptionView: View {
    var select: (Option.ID) async -> Void
    let optionID: Option.ID
    @StateObject var optionViewModel: OptionViewModel
    
    let isSelected: Bool
    
    var body: some View {
        // FIXME: seems that not the entire button is clickable
        Button {
            Task {
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
