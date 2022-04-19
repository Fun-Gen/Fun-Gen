//
//  AuthenticationView.swift
//  Fun Gen
//
//  Created by jules on 4/18/22.
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
                user.signIn(email: email, password: password)
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
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Button {
                user.signUp(email: email, firstName: firstName, lastName: lastName, password: password)
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
