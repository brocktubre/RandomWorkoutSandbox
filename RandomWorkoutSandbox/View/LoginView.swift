//
//  LoginView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/2/21.
//

import SwiftUI
import KeychainSwift

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
let iconGreen = Color(red: 18.0/255.0, green: 168.0/255.0, blue: 157.0/255.0, opacity: 1.0)


struct LoginView: View {
    
    @EnvironmentObject var sessionManagerService: SessionManagerService
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var isShowingSignUpView = false
    
    @State var showFaceId = false
    
    @State var biometricType:String = ""
    
    let checkmark = "checkmark.square"
    @ObservedObject var user = User()
    
    var body: some View {
            VStack{
                WelcomeText(text: "Welcome back!", subText: "Please login to your account.")
                AppIconImage()
                Text(sessionManagerService.loginErrorMessage)
                    .foregroundColor(Color.red)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                Text(sessionManagerService.confirmationSignUpMessage)
                    .foregroundColor(iconGreen)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(colorScheme == .light ? .secondary : iconGreen)
                    TextField("Email/Username", text: $username)
                        .autocapitalization(.none)
                        .foregroundColor(Color.black)
                        .colorScheme(.light)
                    
                }.padding()
                .background(Capsule().fill(lightGreyColor))
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(colorScheme == .light ? .secondary : iconGreen)
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .foregroundColor(Color.black)
                        .colorScheme(.light)
                    Spacer()
                    Button(action: {
                        sessionManagerService.authenticateWithBiometrics(username: username, password: password, user: user)
                        self.showFaceId = sessionManagerService.showFaceId
                    }) {
                        if(biometricType == "Face ID") {
                            Image(systemName: "faceid")
                                .foregroundColor(colorScheme == .light ? .secondary : iconGreen)
                        }
                        else if(biometricType == "Touch ID") {
                            Image("fingerprint")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                        }
                    }
                }.padding()
                .background(Capsule().fill(lightGreyColor))
                HStack {
                    Text("Remember me")
                    Button(action: {
                        user.rememberMe.toggle()
                        sessionManagerService.setRememeberMe(user: user)

                    }) {
                        Image(systemName: user.rememberMe ? "\(checkmark).fill" : checkmark)
                    }
                }.padding(5)
                Button(action:{
                    sessionManagerService.signIn(username: username, password: password, user: user)
                }) {
                    AuthButtonConent(text: "LOGIN")
                        .background(Capsule().fill(iconGreen))
                }.padding(.bottom, 5)
                NavigationLink(
                    destination: SignUpView().environmentObject(sessionManagerService),
                    isActive: $isShowingSignUpView) { EmptyView() }
                Button(action: {
                    self.isShowingSignUpView = true
                }) {
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                        Text("Create one.")
                            .foregroundColor(iconGreen)
                    }
                }
            }.padding()
            .onAppear() {
                biometricType = sessionManagerService.getBiometricType()
                user.rememberMe = sessionManagerService.getRememberMe()
                if(user.rememberMe) {
                    username = sessionManagerService.getUsername()
                    password = sessionManagerService.getPassword()
                }
            }.alert(isPresented: $showFaceId) {
                Alert(title: Text("You must first login to enable \(biometricType) or enable \(biometricType) through your settings."), dismissButton: .default(Text("Ok")))
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State var username: String = ""
    @State var password: String = ""
    
    static var previews: some View {
        NavigationView{
            VStack{
                WelcomeText(text: "Welcome back!", subText: "Please login to your account.")
                AppIconImage()
                Text("Username")
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                Text("Password")
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 10)
                Spacer()
                Button(action:{
                            print("login user")
                }) {
                    AuthButtonConent(text: "LOGIN")
                        .background(Capsule().fill(iconGreen))
                }.padding(.bottom, 10)
            }.padding()
        }
        
    }
}


struct WelcomeText: View {
    var text: String
    var subText: String
    var body: some View {
        VStack(alignment: .center) {
            Text(text)
                .font(.title)
                .fontWeight(.semibold)
            Text(subText)
                .font(.subheadline)
                .padding(.bottom, 10)
                .foregroundColor(.secondary)
        }
    }
}

struct AppIconImage: View {
    var body: some View {
        Image("login-icon")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .padding(.bottom, 5)
            .foregroundColor(Color.blue)
    }
}

struct AuthButtonConent: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
    }
}
