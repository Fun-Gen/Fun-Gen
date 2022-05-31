//
//  CreateActivityView.swift
//  Fun Gen
//
//  Created by Elena on 5/2/22.
//

import SwiftUI

struct CreateActivityView: View {
    @EnvironmentObject var user: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedCategory: Category = .outdoor
    @State var optionList: [String] = []
    @State var newOption = ""
    @State var friendList: [String] = []
    @State var newFriend: String = ""
    @State private var title: String = ""
    @State var friendID: [User.ID] = []
    @State private var showingAlert = false
    @State private var alertText = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Create Activity").font(.title)
                TextField("Enter in activity title", text: $title)
                HStack {
                    Text("Select Category:")
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                        }
                    }
                }
                Group {
                    Text("Options")
                        .font(.title)
                    ForEach(optionList, id: \.self) { item in
                        Text(item)
                    }
                    TextField("Suggest an option", text: $newOption) {
                        self.optionList.append(self.newOption)
                        self.newOption = ""
                    }
                }
                Text("Friends Tagged")
                    .font(.system(.title2))
                ForEach(friendList, id: \.self) { item in
                    Text(item)
                }
                TextField("Name", text: $newFriend) {
                    let saveFriend = self.newFriend
                    Task {
                        do {
                            let newFriendID = try await UserViewModel.user(named: saveFriend)?.id ?? nil
                            if newFriendID != nil {
                                self.friendID.append(newFriendID ?? "")
                                self.friendList.append(saveFriend)
                            }
                        } catch {
                            // TODO: handle error
                            alertText = error.localizedDescription
                            showingAlert = true
                        }
                    }
                    self.newFriend = ""
                }
                .alert("Unable to tag friend", isPresented: $showingAlert) {
                    Button("OK") { }
                } message: {
                    Text(alertText)
                }
            }.padding()
        }.toolbar {
            Button(action: {
                Task {
                    do {
                        _ = try await ActivityViewModel.createActivity(
                            title: title, // Ice Cream Outing
                            category: selectedCategory, // Food
                            author: "\(user.user?.id ?? "")", // author: "eOUU1RDjcphzXd0VTUDhALy6ZB53"
                            optionTitles: optionList, // Mint, Choco, Straw
                            additionalMembers: friendID
                        )
                    } catch {
                        // TODO: handle error
                        alertText = error.localizedDescription
                        showingAlert = true
                    }
                }
                self.presentationMode.wrappedValue.dismiss()
            }, label: { Text("Create") })
            .alert("Unable to create activity", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertText)
            }
        }
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView()
    }
}
