//
//  TempHomeView.swift
//  Fun Gen
//
//  Created by kana on 5/2/22.
//

import SwiftUI

struct TempHomeView: View {
    var body: some View {
        VStack {
            Text("Landing View").padding()
            NavigationLink(destination: VoteView()) {
                Text("Movie Night").foregroundColor(.blue).padding().border(.black)
            }
            NavigationLink(destination: CreateActivityView()) {
                Text("Create New Activity ").foregroundColor(.blue).padding()
            }
        }
    }
}

struct TempHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TempHomeView()
    }
}
