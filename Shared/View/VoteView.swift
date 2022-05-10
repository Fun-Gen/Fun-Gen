//
//  VoteView.swift
//  Fun Gen
//
//  Created by Angkana on 5/2/22.
//
import SwiftUI

struct VoteView: View {
    @ObservedObject var activityViewModel = ActivityViewModel(activityID: "AhdjSLOlTJqb68aXBAWn")

    @State private var optionArray = ["Shrek", "Wall-E", "ET"]
    @State private var isSelected = ""
    @State private var newOption = ""
    
    
        
    // Some default values, will automatically be replaced when call to .activity() method is made
    @State private var act = Activity(id: "1", title: "Movie Night", category: Category.movie, author: "1")
    // VoteView retrieves title, category by using activity(id: Activity.ID) from ActivityViewModel
    var body: some View {
        VStack(alignment: .leading) {
            // Get an activity to retrieve data (title, category, options)
            
            Text("Activity").font(.title).padding(.bottom)
            Text("\(activityViewModel.activity?.title ?? "")").font(.title3)
            
            Text("Category: \(activityViewModel.activity?.category.rawValue.capitalized ?? "")").foregroundColor(.secondary)
            
            Text("Options").font(.title).padding(.top)
            
            // Option selection
            ScrollView {
                VStack(alignment: .leading) {
                    // TODO: Loop through the activity options array...
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
        }.navigationTitle("Vote").padding().padding()
    }
}


struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: Need to create ActicityID and OptionID, store in variable, and pass it in here
        VoteView()
    }
}
