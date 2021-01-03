//
//  ConfirmationView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/3/21.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var sessionManagerService: SessionManagerService
    @State var confirmationCode = ""
    let username: String
    var body: some View {
        NavigationView {
            VStack {
                WelcomeText(text: "Enter Confirmation Code", subText: "Check your email for your confirmation code.")
                Text(sessionManagerService.confirmationErrorMessage)
                    .foregroundColor(Color.red)
                    .fontWeight(.heavy)
                TextField("Confirmation Code", text: $confirmationCode)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Button(action:{
                    sessionManagerService.confirm(username: username, code: confirmationCode)
                }) {
                    AuthButtonConent(text: "CONFIRM")
                        .background(Capsule().fill(iconGreen))
                }.padding(.bottom, 20)
            }.padding()
            
        }
        
        
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "brocktubre")
    }
}
