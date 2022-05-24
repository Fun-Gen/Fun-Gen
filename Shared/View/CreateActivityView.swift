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
    @State var newFriend = ""
    @State private var title: String = ""
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Create Activity").font(.title)
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
                            // FIXME: need to pass [User.ID] instead:
                            additionalMembers: friendList
                        ) // Might leave off friends tagging for beta?
                    } catch {
                        // TODO: handle error
                        print(error)
                    }
                }
                self.presentationMode.wrappedValue.dismiss()
            }, label: { Text("Create") })
        }
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView()
    }
}
