//
//  ProfileView.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/18/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: UserViewModel
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Text("Successfully authenticated \(user.user?.username ?? "")")
            // When user successfully logins they
            // shoud see landing page
            Button {
                do {
                    try user.signOut()
                } catch {
                    self.showingAlert = true
                }
            } label: {
                Text("Sign out")
            }
            .alert("Error signing out. Try again.", isPresented: $showingAlert){
                Button("OK") { }
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
