//
//  VoteView.swift
//  Fun Gen
//
//  Created by kana on 5/1/22.
//

import SwiftUI

struct VoteView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity").font(.title)
            // Activity title should come from
            // user entering a title from
            // Activity Creation page
            Text("")
            // Category should also be grabbed
            // from the Activity.swift as
            // it gets inputted in from the
            // Activity Creation page
            Text("Category: ")
            // You should just be able to scroll
            // through the options, I think
            ScrollView {
            }
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: TempLandingView()) {
                    // TODO: When user clicks Done, tallying/count the user selected option
                    Text("Done")
                }
            }
        }.navigationTitle("Vote").padding()
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView()
    }
}
