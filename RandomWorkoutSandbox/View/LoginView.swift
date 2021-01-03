//
//  LoginView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/2/21.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)


struct LoginView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    var ac = AuthController()
    
    var body: some View {
        VStack{
            Spacer()
            WelcomeText()
            UserImage()
            TextField("Username", text: $username)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action:{
                ac.signIn(username: username, password: password)
            }) {
                LoginButtonContent()
            }.padding(.bottom, 20)
            Button(action:{
                // TODO implement sign up
            }) {
                Text("Need to create a new account?")
                    .foregroundColor(Color.blue)
            }
            Spacer()
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State var username: String = ""
    @State var password: String = ""
    
    static var previews: some View {
        VStack{
            Spacer()
            WelcomeText()
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
                    LoginButtonContent()
            }
        }.padding()
    }
}


struct WelcomeText: View {
    var body: some View {
        Text("Login")
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
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}
