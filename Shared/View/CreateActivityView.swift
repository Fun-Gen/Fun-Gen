//
//  CreateActivityView.swift
//  Fun Gen
//
//  Created by Elena on 5/2/22.
//

import SwiftUI

struct CreateActivityView: View {
    @State private var selectedCategory: Category = .outdoor

    @State var optionList: [String] = []
    @State var newOption = ""
    
    @State var friendList: [String] = []
    @State var newFriend = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create Activity View").padding()
            Text("Input Activity").font(.title).padding()
            TextField("Enter in activity title", text: .constant("")).padding()
            HStack {
                Text("Select Category:")
                // Loop through the category enum in Category.swift using a picker
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
            }.padding()
            
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
                NavigationLink(destination: TempHomeView()) {
                    Text("Create")
                }
            }
        }.padding()
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView()
    }
}
