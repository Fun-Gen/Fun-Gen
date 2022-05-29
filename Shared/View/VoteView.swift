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
    @State private var optionArray = ["OP1", "OP2", "OP3"]
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
                            VoteOptionView(
                                select: { id in
                                    await changeSelected(newID: id, userID: user.id, activity: activity)
                                },
                                optionID: optionID,
                                optionViewModel: OptionViewModel(optionID: optionID),
                                isSelected: selectedOption == optionID
                            )
                        }
                        TextField("Suggest an option", text: $newOption) {
                            // FIXME: add to database
                                optionArray.append(self.newOption)
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
        }
        .navigationTitle("Vote")
        .padding()
        .toolbar {
            Button(action: {
                Task {
                    do {
                        if let activityID = activityViewModel.activity?.id {
                            _ = try await ActivityViewModel.deleteActivity(activityID)
                        }
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                }
                self.presentationMode.wrappedValue.dismiss()
            }, label: { Text("Delete") })
        }
    }
    
    func setUserSelectedOptionOnLoad(userID: User.ID, in activity: Activity) {
        if activity.members.contains(userID) {
            for optionID in activity.options.keys {
                if let votedOption = activity.options[optionID] {
                    if votedOption.members.contains(userID) {
                        selectedOption = optionID
                    }
                }
            }
        }
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
            .environmentObject(ActivityViewModel(activityID: "AhdjSLOlTJqb68aXBAWn"))
            .environmentObject(UserViewModel())
    }
}
