//
//  ProfileView.swift
//  Fun Gen
//
//  Created by jules on 4/18/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: UserViewModel
    
    var body: some View {
        VStack {
            Text("Successfully authenticated \(user.user?.firstName ?? "") \(user.user?.lastName ?? "")")
            Button {
                user.signOut()
            } label: {
                Text("Sign out")
            }
        }
    }
}

 struct ProfileView_Previews: PreviewProvider {
     static var previews: some View {
         ProfileView()
        .environmentObject(UserViewModel())
     }
 }
