//
//  VoteView.swift
//  Fun Gen
//
//  Created by Angkana on 5/2/22.
//

import SwiftUI

struct VoteView: View {
    @EnvironmentObject var activityViewModel: ActivityViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedOption = ""
    @State private var newOption = ""
    
    var sortedOptionIDs: [Option.ID] {
        activityViewModel.activity?.options.keys.sorted() ?? []
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            if let activity = activityViewModel.activity,
               let user = userViewModel.user {
                Text("Activity").font(.title).padding(.bottom)
                Text("Title: \(activity.title)").foregroundColor(.secondary)
                Text("Category: \(activity.category.rawValue.capitalized)").foregroundColor(.secondary)
                Text("Options").font(.title).padding(.top)
                // Option selection
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(sortedOptionIDs, id: \.self) { optionID in
                            HStack {
                                Button {
                                    Task {
                                        do {
                                            try await ActivityViewModel.removeOption(optionID, fromActivity: activity.id)
                                        } catch {
                                            // TODO: handle error
                                            print(error)
                                        }
                                    }
                                    
                                    print(optionID)
                                } label: {
                                    Image(systemName: "x.circle")
                                }
                                VoteOptionView(
                                    select: { id in
                                        await changeSelected(newID: id, userID: user.id, activity: activity)
                                    },
                                    optionID: optionID,
                                    optionViewModel: OptionViewModel(optionID: optionID),
                                    isSelected: selectedOption == optionID
                                )
                            }
                        }
//                        .onDelete { indexset in
//                            for index in indexset {
//                                Task {
//                                    do {
//                                        try await ActivityViewModel.removeOption(sortedOptionIDs[index], fromActivity: activity.id)
//                                    } catch {
//                                        // TODO: handle error
//                                        print(error)
//                                    }
//                                }
//                            }
//                        }
                        TextField("Suggest an option", text: $newOption) {
                            let nOption = self.newOption
                            Task {
                                do {
                                    try await ActivityViewModel.addOption(title: nOption, byUser: user.id, toActivity: activity.id)
                                } catch {
                                    // TODO: handle error
                                    print(error)
                                }
                            }
                            self.newOption = ""
                        }.padding(4)
                    }
                }
                .onAppear {
                    setUserSelectedOptionOnLoad(userID: user.id, in: activity)
                }
            } else {
                Text("Loading...")
            }
            
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Done")
                    })
            }
        }.navigationTitle("Vote").padding()
    }
    
    func setUserSelectedOptionOnLoad(userID: User.ID, in activity: Activity) {
        // FIXME: look for selected activity for user if any
        // TODO: selectedOption = ...
    }

    func changeSelected(newID: Option.ID, userID: User.ID, activity: Activity) async {
        do {
            if selectedOption.isEmpty {
                    try await ActivityViewModel
                        .changeVote(ofUser: userID,
                                    addTo: newID,
                                    inActivity: activity.id)
                    selectedOption = newID
            } else if selectedOption == newID {
                    try await ActivityViewModel
                        .changeVote(ofUser: userID,
                                    removeFrom: newID,
                                    inActivity: activity.id)
                    selectedOption = ""
            } else {
                    try await ActivityViewModel
                        .changeVote(ofUser: userID,
                                    removeFrom: selectedOption,
                                    addTo: newID,
                                    inActivity: activity.id)
                    selectedOption = newID
            }
        } catch {
            // TODO: Handle Error
            print("Error")
        }
        return
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView()
            .environmentObject(ActivityViewModel(activityID: "tsvmX4uowJbd2yioyWIp"))
            .environmentObject(UserViewModel())
    }
}
