//
//  RandomWorkoutSandboxApp.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct RandomWorkoutSandboxApp: App {
    @ObservedObject var sessionManagerService = SessionManagerService()
    
    init() {
        configureAmplify()
        sessionManagerService.getCurrentAuthUser()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch sessionManagerService.authState {
                    case .login:
                        LoginView()
                            .environmentObject(sessionManagerService)
                    case .signUp:
                        SignUpView()
                            .environmentObject(sessionManagerService)
                    case .confirmCode(let username):
                        ConfirmationView(username: username)
                            .environmentObject(sessionManagerService)
                    case .session(let user):
                        EquipmentListView(user: user)
                            .environmentObject(sessionManagerService)
                }
            }
        }
    }
    
    func configureAmplify() {
           do {
               // Storage
               try Amplify.add(plugin: AWSCognitoAuthPlugin())
               try Amplify.add(plugin: AWSAPIPlugin())
               try Amplify.configure()
               
                print("Amplify configured with API and Auth plugin")
            } catch {
                    print("Failed to initialize Amplify with \(error)")
            }
       }
}
