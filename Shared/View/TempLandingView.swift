//
//  TempLandingView.swift
//  Fun Gen
//
//  Created by kana on 5/1/22.
//

import SwiftUI

struct TempLandingView: View {
    var body: some View {
        VStack {
            Text("Landing View").padding()
            NavigationLink(destination: VoteView()) {
                Text("Movie Night").foregroundColor(.blue).padding().border(.black)
            }
            NavigationLink(destination: TempCreateActivityView()) {
                Text("Create New Activity ").foregroundColor(.blue).padding()
            }
        }
    }
}

struct TempLandingView_Previews: PreviewProvider {
    static var previews: some View {
        TempLandingView()
    }
}
