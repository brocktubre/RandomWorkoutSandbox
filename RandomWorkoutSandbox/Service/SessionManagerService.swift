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
    @Published var loginErrorMessage: String = ""
    @Published var signupErrorMessage: String = ""
    @Published var confirmationErrorMessage: String = ""
    @Published var confirmationSignUpMessage: String = ""
    @Published var resendConfirmationMessage: String = ""
    private var confirmationUserName: String = ""
    
    func getCurrentAuthUser() {
        let user = Amplify.Auth.getCurrentUser()
        if (user != nil) {
            authState = .session(user: user!)
        }
        else {
            authState = .login
        }
    }
    
    func getUserId() -> String {
        guard let userId = Amplify.Auth.getCurrentUser()?.userId else { return ""}
        return userId
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin(){
        authState = .login
    }
    
    func signUp(username: String, password: String, confrimPassword: String, email: String) {
        let matchingPasswords = checkMatchingPasswords(password: password, passwordConfirm: confrimPassword)
        if(!matchingPasswords) {
            self.signupErrorMessage = "Passwords do not match."
            return
        }
        self.confirmationUserName = username
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
                    DispatchQueue.main.async {
                        self!.signupErrorMessage = error.errorDescription
                    }
                    print("Sign up error", error)
            }
        }
    }
    
    func checkMatchingPasswords(password: String, passwordConfirm: String) -> Bool {
        if(password != passwordConfirm) {
            return false
        } else {
            return true
        }
    }
    
    func confirm(username: String, code: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code) { [weak self] result in
            switch result {
                case .success(let confirmResults):
                    print("Confirm signUp succeeded \(confirmResults)")
                    if(confirmResults.isSignupComplete) {
                        DispatchQueue.main.async {
                            self?.confirmationSignUpMessage = "Congrats! You're ready to sign in with \(username)."
                            self?.showLogin()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self!.confirmationErrorMessage = error.errorDescription
                    }
                    print("An error occurred while confirming sign up \(error)")
            }
        }
    }
    
    func signIn(username: String, password: String) {
        self.confirmationSignUpMessage = ""
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
                        self!.loginErrorMessage = error.errorDescription
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
        self.loginErrorMessage = ""
        self.signupErrorMessage = ""
        self.confirmationErrorMessage = ""
        self.resendConfirmationMessage = ""
        self.confirmationSignUpMessage = ""
    }
    
    func resendCode(){
        _ = Amplify.Auth.resendSignUpCode(for: self.confirmationUserName) { [weak self] result in
            switch result {
            case .success(let resendSignUpCodeResult):
                self?.resendConfirmationMessage = "New confirmation code sent."
            case .failure(let error):
                self?.confirmationErrorMessage = error.errorDescription
            }
        }
    }
}
