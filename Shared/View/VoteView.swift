//
//  VoteView.swift
//  Fun Gen
//
//  Created by Angkana on 5/2/22.
//

import SwiftUI

struct VoteView: View {
    @EnvironmentObject var user: UserViewModel
    @EnvironmentObject var activity: ActivityViewModel
    
    @State private var optionArray = ["Shrek", "Wall-E", "ET"]
    @State private var isSelected = ""
    @State private var newOption = ""
    
    // TODO: VoteView retrieves title, category, and options by using activity(id: Activity.ID) from ActivityViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity").font(.title).padding(.bottom)
            
            // Testing purposes
            Text("activityid \(activity.activity?.id ?? "")")
            
            // Text(tempActivty.title).font(.title3)
            // Text("Category: \(tempActivty.category.rawValue.capitalized)").foregroundColor(.secondary)
            Text("Options").font(.title).padding(.top)
            // Option selection
            ScrollView {
                VStack(alignment: .leading) {
                    // TODO: Correctly update fields from Model files when user inputs data
                    ForEach(optionArray, id: \.self) { item in
                        Button {
                            self.isSelected = item
                        } label: {
                            Text(item)
                        }.font(.body)
                            .padding(4)
                            .padding(.trailing, 200)
                            .background(self.isSelected == item ? Color.yellow : Color.white)
                            .cornerRadius(16)
                    }
                    TextField("Suggest an option", text: $newOption) {
                            optionArray.append(self.newOption)
                            self.newOption = ""
                    }.padding(4)
                }
            }
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: HomeView()) {
                    Text("Done")
                }
            }
        }.navigationTitle("Vote").padding()
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView().environmentObject(UserViewModel()).environmentObject(ActivityViewModel(activityID: "1"))
    }
}
