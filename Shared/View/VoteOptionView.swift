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
        Button {
            Task {
                await select(optionID)
            }
        } label: {
            if let option = optionViewModel.option {
                Text(option.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Loading...")
            }
        }
        .padding(4)
        .background(isSelected ? Color.yellow : Color.white)
        .cornerRadius(16)
    }
}

// struct VoteOptionView_Previews: PreviewProvider {
//     static var previews: some View {
//         VoteOptionView(optionID: <#Option.ID#>, activity: <#Activity#>, optionViewModel: <#OptionViewModel#>)
//     }
// }
