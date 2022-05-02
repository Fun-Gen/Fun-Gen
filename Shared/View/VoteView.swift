//
//  VoteView.swift
//  Fun Gen
//
//  Created by kana on 5/1/22.
//

import SwiftUI

struct VoteView: View {
    // Testing Hardcoded values
    var tempActivty = Activity(
        id: "123",
        title: "What movie should we watch tonight?",
        category: Category.movie,
        author: "mightyDonut",
        voteCount: 3
    )
    var optionArray = ["Shrek", "Wall-E", "ET"]
    
    @State var isSelected = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity").font(.title).padding(.bottom)
            // Activity title should come from
            // user entering a title from
            // Activity Creation page
            Text(tempActivty.title).font(.title3)
            // Category should also be grabbed
            // from the Activity.swift as
            // it gets inputted in from the
            // Activity Creation page
            Text("Category: \(tempActivty.category.rawValue.capitalized)").foregroundColor(.secondary)
            // You should just be able to scroll
            // through the options, I think
            Text("Options").font(.title).padding(.top)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(optionArray, id: \.self) { item in
                        Button(action: {
                            self.isSelected = item
                        })
                        {
                            Text(item)
                        }.font(.body)
                            .padding(4).padding(.trailing, 200).background(self.isSelected == item ? Color.yellow : Color.white).cornerRadius(16)
                    }
                }
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
