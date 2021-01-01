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
    
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
