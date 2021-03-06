//
//  ConfirmationView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/3/21.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var sessionManagerService: SessionManagerService
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var confirmationCode = ""
    let username: String
    var body: some View {
            VStack {
                Image(systemName: "envelope.badge")
                    .foregroundColor(iconGreen)
                    .imageScale(.large)
                    .font(.system(size: 150))
                Spacer()
                WelcomeText(text: "Enter Confirmation Code", subText: "Check your email for your confirmation code.")
                Text(sessionManagerService.confirmationErrorMessage)
                    .foregroundColor(Color.red)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                HStack {
                    Image(systemName: "pencil")
                        .foregroundColor(colorScheme == .light ? .secondary : iconGreen)
                    TextField("Confirmation Code", text: $confirmationCode)
                        .colorScheme(.light)
                    
                }.padding()
                .background(Capsule().fill(lightGreyColor))
                Button(action:{
                    sessionManagerService.confirm(username: username, code: confirmationCode)
                }) {
                    AuthButtonConent(text: "CONFIRM")
                        .background(Capsule().fill(iconGreen))
                }.padding(.bottom, 20)
                Button(action: {
                    sessionManagerService.resendCode()
                }) {
                    HStack {
                        Text("Need another code?")
                            .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                        Text("Resend code.")
                            .foregroundColor(iconGreen)
                    }
                }
                Text(sessionManagerService.resendConfirmationMessage)
                    .foregroundColor(iconGreen)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                Spacer()
            }.padding()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "brocktubre")
    }
}
