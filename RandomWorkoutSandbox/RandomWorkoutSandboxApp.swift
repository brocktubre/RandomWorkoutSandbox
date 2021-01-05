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
                switch sessionManagerService.authState {
                    case .login:
                        NavigationView {
                            LoginView()
                                .environmentObject(sessionManagerService)
                        }.navigationViewStyle(StackNavigationViewStyle())
                    case .signUp:
                        NavigationView {
                            SignUpView()
                                .environmentObject(sessionManagerService)
                        }.navigationViewStyle(StackNavigationViewStyle())
                    case .confirmCode(let username):
                        NavigationView {
                            ConfirmationView(username: username)
                                .environmentObject(sessionManagerService)
                        }.navigationViewStyle(StackNavigationViewStyle())
                    case .session(let user):
                        NavigationView {
                                LoadingDataView(user: user)
                                .environmentObject(sessionManagerService)
                        }.navigationViewStyle(StackNavigationViewStyle())
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
