//
//  SessionManagerService.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/3/21.
//

import Amplify

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
}

final class SessionManagerService: ObservableObject {
    @Published var authState: AuthState = .login
    @Published var errorMessage: String = ""
    
    func getCurrentAuthUser() {
        let user = Amplify.Auth.getCurrentUser()
        if (user != nil) {
            authState = .session(user: user!)
        }
        else {
            authState = .login
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin(){
        authState = .login
    }
    
    func signUp(username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        _ = Amplify.Auth.signUp(username: username, password: password, options: options) {
            [weak self] result in
            
            switch result {
                case .success(let signUpResult):
                    print("Sign up results: ", signUpResult)
                    switch signUpResult.nextStep {
                    case .done:
                        print("Finished sign up")
                    case .confirmUser(let details, _):
                        print(details ?? "no details")
                        
                        DispatchQueue.main.async {
                            self?.authState = .confirmCode(username: username)
                        }
                    }
                case .failure(let error):
                    print("Sign up error", error)
            }
        }
    }
    
    func confirm(username: String, code: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code) { [weak self] result in
            switch result {
                case .success(let confirmResults):
                    print("Confirm signUp succeeded \(confirmResults)")
                    if(confirmResults.isSignupComplete) {
                        DispatchQueue.main.async {
                            self?.showLogin()
                        }
                    }
                case .failure(let error):
                    print("An error occurred while confirming sign up \(error)")
            }
        }
    }
    
    func signIn(username: String, password: String) {
        _ = Amplify.Auth.signIn(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let signInResult):
                    print("User successfully signed in \(signInResult)")
                if(signInResult.isSignedIn) {
                    DispatchQueue.main.async {
                        self?.completeSignOut()
                    }
                }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self!.errorMessage = error.errorDescription
                    }
                    print("An error occurred while signing in \(error)")
            }
        }
    }
    
    func signOut() {
        _ = Amplify.Auth.signOut() { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                }
            case .failure(let error):
                print("Sign out error \(error)")
            }
            
        }
    }
    
    func completeSignOut() {
        self.getCurrentAuthUser()
        self.errorMessage = ""
    }
}
