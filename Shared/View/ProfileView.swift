//
//  ProfileView.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/18/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: UserViewModel
    
    var body: some View {
        VStack {
            Text("Successfully authenticated \(user.user?.username ?? "")")
            // When user successfully logins they
            // shoud see landing page
            TempLandingView()
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
