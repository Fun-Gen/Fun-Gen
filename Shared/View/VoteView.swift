//
//  VoteView.swift
//  Fun Gen
//
//  Created by Angkana on 5/2/22.
//

import SwiftUI

struct VoteView: View {
    @EnvironmentObject var activityViewModel: ActivityViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var optionArray = ["OP1", "OP2", "OP3"]
    @State private var isSelected = ""
    @State private var newOption = ""
    
    var sortedOptionIDs: [Option.ID] {
        activityViewModel.activity?.options.keys.sorted() ?? []
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let activity = activityViewModel.activity {
                Text("Activity").font(.title).padding(.bottom)
                
                Text("activityid \(activity.id)")
                Text("Title: \(activity.title)").foregroundColor(.secondary)
                Text("Category: \(activity.category.rawValue.capitalized)").foregroundColor(.secondary)
                Text("Options").font(.title).padding(.top)
                // Option selection
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(sortedOptionIDs, id: \.self) { optionID in
                            VoteOptionView(optionID: optionID,
                                           activity: activity,
                                           optionViewModel: OptionViewModel(optionID: optionID))
                        }
                        TextField("Suggest an option", text: $newOption) {
                                optionArray.append(self.newOption)
                                self.newOption = ""
                        }.padding(4)
                    }
                }
            } else {
                Text("Loading...")
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
        VoteView()
            .environmentObject(ActivityViewModel(activityID: "AhdjSLOlTJqb68aXBAWn"))
    }
}
