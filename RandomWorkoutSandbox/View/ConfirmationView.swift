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
                WelcomeText(text: "Enter Confirmation Code")
                TextField("Confirmation Code", text: $confirmationCode)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Button(action:{
                    sessionManagerService.confirm(username: username, code: confirmationCode)
                }) {
                    LoginButtonContent(text: "Confirm", color: Color.green)
                }
            }.padding()
            
        }
        
        
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "brocktubre")
    }
}
