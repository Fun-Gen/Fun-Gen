//
//  VoteView.swift
//  Fun Gen
//
//  Created by kana on 5/1/22.
//

import SwiftUI

struct VoteView: View {
    // Hardcoded values to test
    @State private var tempActivty = Activity(
        id: "123",
        title: "What movie should we watch tonight?",
        category: Category.movie,
        author: "mightyDonut",
        voteCount: 3
    )
    @State private var optionArray = ["Shrek", "Wall-E", "ET"]
    @State private var isSelected = ""
    @State private var newOption = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity").font(.title).padding(.bottom)
            Text(tempActivty.title).font(.title3)
            Text("Category: \(tempActivty.category.rawValue.capitalized)").foregroundColor(.secondary)
            Text("Options").font(.title).padding(.top)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(optionArray, id: \.self) { item in
                        Button(action: { self.isSelected = item }) {
                            Text(item)
                        }.font(.body)
                            .padding(4)
                            .padding(.trailing, 200)
                            .background(self.isSelected == item ? Color.yellow : Color.white)
                            .cornerRadius(16)
                    }
                    TextField("Suggest an option", text: $newOption) {
                            optionArray.append(self.newOption)
                            self.newOption = ""
                    }.padding(4)
                }
            }
       
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: TempLandingView()) {
                    Button("Done") { tempActivty.voteCount += 1 }
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
