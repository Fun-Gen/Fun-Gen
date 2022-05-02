//
//  TempCreateActivityView.swift
//  Fun Gen
//
//  Created by kana on 5/1/22.
//

import SwiftUI

struct TempCreateActivityView: View {
    @State private var selectedCategory: Category = .outdoor
    @State var optionList: [String] = []
    @State var newOption = ""
    @State var friendList: [String] = []
    @State var newFriend = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Create Activity View").padding()
            Text("Input Activity").font(.title).padding()
            // Input activity title and update the activity variable in Activity.swift
            TextField("Enter in activity title", text: .constant("")).padding()
            // Once user selects the category, update the category state in Activity.swift
            HStack {
                Text("Select Category:")
                // Loop through the category enum in Category.swift using a picker
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
            }.padding()
            
            Text("Options")
                .font(.title).padding()
            ForEach(optionList, id: \.self) { item in
                Button(item) {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }.padding(5)
            }.padding(.leading)
            TextField("Suggest an option", text: $newOption) {
                self.optionList.append(self.newOption)
                self.newOption = ""
            }.padding()
            
            Group {
                Text("Friends Tagged")
                    .font(.title)
                    .padding()
                ForEach(friendList, id: \.self) { item in
                    Text(item).padding(5)
                }.padding(.leading)
                TextField("Name", text: $newFriend) {
                    self.friendList.append(self.newFriend)
                    self.newFriend = ""
                }.padding()
            }
            
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: TempLandingView()) {
                    Text("Create")
                }
            }
        }.padding()
    }
}

struct TempCreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        TempCreateActivityView()
    }
}
