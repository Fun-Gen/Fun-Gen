//
//  VoteView.swift
//  Fun Gen
//
//  Created by Angkana on 5/2/22.
//

import SwiftUI

struct VoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var activity: Activity
    @State private var optionArray = ["OP1", "OP2", "OP3"]
    @State private var isSelected = ""
    @State private var newOption = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity").font(.title).padding(.bottom)
            Text(activity.title).font(.title3)
            Text("Category: Temp").foregroundColor(.secondary)
            Text("Options").font(.title).padding(.top)
            // Option selection
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(optionArray, id: \.self) { item in
                        Button {
                            self.isSelected = item
                        } label: {
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
                Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: {Text("Done")})
            }
        }.navigationTitle("Vote").padding()
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView(activity: testActivities[0])
    }
}
