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
                HStack {
                    Image(systemName: "pencil")
                        .foregroundColor(.secondary)
                    TextField("Confirmation Code", text: $confirmationCode)
                    
                }.padding()
                .background(Capsule().fill(lightGreyColor))
                Button(action:{
                    sessionManagerService.confirm(username: username, code: confirmationCode)
                }) {
                    AuthButtonConent(text: "CONFIRM")
                        .background(Capsule().fill(iconGreen))
                }.padding(.bottom, 20)
                Spacer()
            }.padding()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "brocktubre")
    }
}
