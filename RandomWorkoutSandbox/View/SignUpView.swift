//
//  SignUpView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/3/21.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var sessionManagerService: SessionManagerService
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var isLoginShowing = false
    
    var body: some View {
            VStack {
                AppIconImage()
                WelcomeText(text: "Create a new account.", subText: "Please enter your information.")
                Text(sessionManagerService.signupErrorMessage)
                    .foregroundColor(Color.red)
                    .fontWeight(.heavy)
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(colorScheme == .light ? .secondary : iconGreen)
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .colorScheme(.light)
                    
                }.padding()
                .background(Capsule().fill(lightGreyColor))
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(colorScheme == .light ? .secondary : iconGreen)
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .colorScheme(.light)
                        
                }.padding()
                .background(Capsule().fill(lightGreyColor))
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(colorScheme == .light ? .secondary : iconGreen)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .autocapitalization(.none)
                        .colorScheme(.light)
                }.padding()
                .background(Capsule().fill(lightGreyColor))
                Button(action:{
                    sessionManagerService.signUp(username: email, password: password, confrimPassword: confirmPassword, email: email)
                }) {
                    AuthButtonConent(text: "SIGN UP")
                        .background(Capsule().fill(iconGreen))
                }.padding(.bottom, 20)
                NavigationLink(destination: LoginView().environmentObject(sessionManagerService), isActive: $isLoginShowing) { EmptyView() }
                Button(action: {
                    self.isLoginShowing = true
                }) {
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                        Text("Login here.")
                            .foregroundColor(iconGreen)
                    }
                }
            }.padding()
        }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
