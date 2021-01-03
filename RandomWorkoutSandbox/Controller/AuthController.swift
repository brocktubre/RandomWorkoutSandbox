//
//  AuthController.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/2/21.
//

import UIKit
import Amplify
import Combine
import RxSwift

class AuthController: UIViewController {
    
    func signIn(username: String, password: String) -> AnyCancellable {
        Amplify.Auth.signIn(username: username, password: password)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Sign in failed \(authError)")
                }
            }
            receiveValue: { _ in
                print("Sign in succeeded")
            }
    }
    
    
    func signUp(username: String, password: String, email: String) -> AnyCancellable {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        let sink = Amplify.Auth.signUp(username: username, password: password, options: options)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("An error occurred while registering a user \(authError)")
                }
            }
            receiveValue: { signUpResult in
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                }

            }
        return sink
    }
}
