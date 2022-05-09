//
//  CreateActivityView.swift
//  Fun Gen
//
//  Created by Elena, Angkana on 5/2/22.
//

import SwiftUI

struct CreateActivityView: View {
    @EnvironmentObject var user: UserViewModel
    @EnvironmentObject var activity: ActivityViewModel
    
    @State private var inputTitle = ""
    @State private var selectedCategory: Category = .outdoor
    
    @State var optionList: [String] = []
    @State var newOption = ""
    
    @State var friendList: [String] = []
    @State var newFriend = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Saves title
            TextField("Enter in activity title", text: $inputTitle).padding(.leading)
            
            // Testing purposes
            // Text("userid \(user.user?.id ?? "")")
            
            // Saves category
            HStack {
                Text("Select Category:")
                // Loop through the category enum in Category.swift using a picker
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
            }.padding()
            
            // Saves option
            Group {
                Text("Options")
                    .font(.title).padding()
                ForEach(optionList, id: \.self) { item in
                    Text(item).padding(.leading).padding(.bottom, 4)
                }
                TextField("Suggest an option", text: $newOption) {
                    self.optionList.append(self.newOption)
                    self.newOption = ""
                }.padding()
            }
            
            // Saves friends
            Text("Friends Tagged")
                .font(.system(.title2))
                .padding()
            ForEach(friendList, id: \.self) { item in
                Text(item).padding(.leading).padding(.bottom, 4)
            }
            TextField("Name", text: $newFriend) {
                self.friendList.append(self.newFriend)
                self.newFriend = ""
            }.padding()
            Spacer()
            HStack {
                Spacer()
                // Clicking on button will send info to database
                Button {
                    Task {
                        do {
                            _ = try await ActivityViewModel.createActivity(
                                    title: inputTitle, // Ice Cream Outing
                                    category: selectedCategory, // Food
                                    author: "\(user.user?.id ?? "")", // author: "eOUU1RDjcphzXd0VTUDhALy6ZB53"
                                    optionTitles: optionList, // Mint, Choco, Straw
                                    additionalMembers: []) // Might leave off friends tagging for beta?
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    NavigationLink(destination: VoteView()) {
                        Text("Create")
                    }
                }
            }
        }.navigationTitle("Input Activity").padding().padding()
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView().environmentObject(UserViewModel()).environmentObject(ActivityViewModel(activityID: "1"))
            // Not sure how to get unique ActivityID from database
    }
}
