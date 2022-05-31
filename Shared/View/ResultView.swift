//
//  ResultView.swift
//  Fun Gen
//
//  Created by Finnigan Johnson on 5/29/22.
//

import SwiftUI

struct ResultView: View {
    @StateObject var activityViewModel: ActivityViewModel
    @StateObject var optionViewModel: OptionViewModel
    
    var body: some View {
        if let option = optionViewModel.option,
           let activity = activityViewModel.activity {
            Text("Title: " + activity.title)
            Spacer()
            Text("Winner: " + option.title)
            Spacer()
        } else {
            Text("Loading...")
        }
    }
}

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView()
//    }
//}
