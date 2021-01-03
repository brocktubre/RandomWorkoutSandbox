//
//  LoginView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/2/21.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)


struct LoginView: View {
    
    @EnvironmentObject var sessionManagerService: SessionManagerService
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var isActive: Bool = false
    
    var body: some View {
            VStack{
                Spacer()
                WelcomeText(text: "Login")
                UserImage()
                TextField("Username", text: $username)
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
                    sessionManagerService.signIn(username: username, password: password)
                }) {
                    LoginButtonContent(text: "LOGIN", color: Color.green)
                }.padding(.bottom, 20)
                Button(action: {
                    sessionManagerService.showSignUp()
                }) {
                    Text("Need to create a new account?")
                        .foregroundColor(Color.blue)
                }
//                NavigationLink(destination: SignUpView(), label: {
//                        Text("Need to create a new account?")
//                            .foregroundColor(Color.blue)
//                })
                Spacer()
            }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State var username: String = ""
    @State var password: String = ""
    
    static var previews: some View {
        NavigationView{
            VStack{
                Spacer()
                WelcomeText(text: "Login")
                UserImage()
                Text("Username")
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Text("Password")
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Spacer()
                Button(action:
                        {
                            print("login user")
                        }) {
                    LoginButtonContent(text: "LOGIN", color: Color.green)
                }
            }.padding()
        }
        
    }
}


struct WelcomeText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct UserImage: View {
    var body: some View {
        Image(systemName: "person.crop.circle")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
            .foregroundColor(Color.blue)
    }
}

struct LoginButtonContent: View {
    var text: String
    var color: Color
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(color)
            .cornerRadius(15.0)
    }
}
