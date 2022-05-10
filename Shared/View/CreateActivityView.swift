//
//  CreateActivityView.swift
//  Fun Gen
//
//  Created by Elena on 5/2/22.
//

import SwiftUI

struct CreateActivityView: View {
    @EnvironmentObject var activityStore: ActivityStore
    @EnvironmentObject var user: UserViewModel

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedCategory: Category = .outdoor
    @State var optionList: [String] = []
    @State var newOption = ""
    @State var friendList: [String] = []
    @State var newFriend = ""
    @State private var title: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create Activity View")
            Text("Input Activity").font(.title)
            TextField("Enter in activity title", text: $title)
            HStack {
                Text("Select Category:")
                // Loop through the category enum in Category.swift using a picker
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
                self.friendList.append(self.newFriend)
                self.newFriend = ""
            }
            HStack {
                Spacer()
                Button(action: {
                    Task {
                        do {
                            var activityDetails = try await ActivityViewModel.createActivity(
                                    title: title, // Ice Cream Outing
                                    category: selectedCategory, // Food
                                    author: "\(user.user?.id ?? "")", // author: "eOUU1RDjcphzXd0VTUDhALy6ZB53"
                                    optionTitles: optionList, // Mint, Choco, Straw
                                    additionalMembers: []) // Might leave off friends tagging for beta?
                        } catch {
                            print(error)
                        }
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Create") })
            }
        }.padding()
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView().environmentObject(ActivityStore(activities: testActivities))
    }
}
