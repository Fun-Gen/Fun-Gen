//
//  TempCreateActivityView.swift
//  Fun Gen
//
//  Created by kana on 5/1/22.
//

import SwiftUI

struct TempCreateActivityView: View {
    @State private var selectedCategory: Category = .outdoor

    var body: some View {
        VStack {
            Text("Create Activity View")
            // Input activity title and update the state variable
            // Input the category and update the state variable
            HStack {
                Text("Categories:")
                // Loop through the category enum in Category.swift using a picker
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: TempLandingView()) {
                    Text("Create")
                }
            }.padding()
        }
    }
}

struct TempCreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        TempCreateActivityView()
    }
}
