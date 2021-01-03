//
//  SignUpView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/3/21.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var sessionManagerService: SessionManagerService
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
            VStack{
                WelcomeText(text: "Sign Up")
                TextField("Username", text: $username)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .autocapitalization(.none)
                TextField("Email", text: $email)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .autocapitalization(.none)
                Button(action:{
                    sessionManagerService.signUp(username: username, password: password, email: email)
                }) {
                    LoginButtonContent(text: "SIGN UP", color: Color.blue)
                }.padding(.bottom, 20)
                Button(action: {
                    sessionManagerService.showLogin()
                }) {
                    Text("Already have an account? Log in here.")
                        .foregroundColor(Color.blue)
                }
//                    NavigationLink(destination: LoginView()) {
//                        Text("Already have an account? Log in here.")
//                            .foregroundColor(Color.blue)
//                    }
                }.padding()
                Spacer()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
