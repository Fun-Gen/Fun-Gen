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
            Text("Activity").font(.title).padding(.leading)
            TextField("Enter in activity title", text: $inputTitle).padding(.leading)
            
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
            
            Spacer()
            HStack {
                Spacer()
                // Clicking on button will send info to database
                Button {
                    Task {
                        do {
                            var activityDetails = try await ActivityViewModel.createActivity(
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
                        Text("Submit").foregroundColor(Color.blue)
                    }
                }
//                Spacer()
//                NavigationLink(destination: VoteView()) {
//                    Text("Next").foregroundColor(Color.blue)
//                }
            }
        }.navigationTitle("Input Activity").padding()
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView().environmentObject(UserViewModel()).environmentObject(ActivityViewModel(activityID: "1"))
            // Not sure how to get unique ActivityID from database
    }
}
