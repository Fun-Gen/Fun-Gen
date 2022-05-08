//
//  AuthenticationView.swift
//  Fun Gen
//
//  Created by Julian Burrington on 4/18/22.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack {
            SignInView()
            NavigationLink("Sign up!", destination: SignUpView())
        }
    }
}

struct SignInView: View {
    @EnvironmentObject var user: UserViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Button {
                Task {
                    do {
                        try await user.signIn(email: email, password: password)
                    } catch {
                        // TODO: display error to user
                        print(error)
                    }
                }
            } label: {
                Text("Sign in")
            }
        }
    }
}

struct SignUpView: View {
    @EnvironmentObject var user: UserViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Button {
                Task {
                    do {
                        try await user.signUp(email: email, username: username, password: password)
                    } catch {
                        // TODO: display error to user
                        print(error)
                    }
                }
            } label: {
                Text("Sign Up")
            }
        }
    }
}

 struct AuthenticationView_Previews: PreviewProvider {
     static var previews: some View {
         AuthenticationView()
     }
 }
