//
//  SessionManagerService.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/3/21.
//

import Amplify
import LocalAuthentication
import KeychainSwift

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
}

struct Keys {
    static let username = "username"
    static let password  = "password"
    static let rememberMe = "rememberMe"
}

final class SessionManagerService: ObservableObject {
    @Published var authState: AuthState = .login
    @Published var loginErrorMessage: String = ""
    @Published var signupErrorMessage: String = ""
    @Published var confirmationErrorMessage: String = ""
    @Published var confirmationSignUpMessage: String = ""

    @Published var isUnlocked: Bool = false
    @Published var showFaceId: Bool = false
    @Published var biometricType: String = ""

    @Published var resendConfirmationMessage: String = ""
    private var confirmationUserName: String = ""
    
    let keychain = KeychainSwift(keyPrefix: "randommovement_")
    
    func getCurrentAuthUser() {
        let user = Amplify.Auth.getCurrentUser()
        if (user != nil) {
            authState = .session(user: user!)
        }
        else {
            authState = .login
        }
    }
    
    func getBiometricType() -> String {
        let context = LAContext()
        var error: NSError?
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if(context.biometryType == LABiometryType.faceID) {
            self.biometricType = "Face ID"
        } else if(context.biometryType == LABiometryType.touchID) {
            self.biometricType = "Touch ID"
        } else {
            self.biometricType = ""
        }
        return self.biometricType

    }
    
    func authenticateWithBiometrics(username: String, password: String, user: User) {
        let context = LAContext()
        var error: NSError?
        
        // Tries to grab the username and password
        // stored in the key chain. If they exists
        // the user does not have to enter thier creditials and they can
        // use biometrics to allow them to login
        let username = self.getUsername()
        let password = self.getPassword()

        if(username == "" && password == "") {
            self.showFaceId = true
            return
        }
        
        // Does the device have biometric capabilities?
        if(context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)){
            let reason = "We need to access your device data to authenticate your login."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if(success) {
                        self.isUnlocked = true
                        self.signIn(username: username, password: password, user: user)
                    } else {
                        // there was a problem
                        return
                    }
                }
            }
        } else {
            return
        }
    }
    
    func signInWithBiometrics(){
       
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
    
    func signIn(username: String, password: String, user: User) {
        self.confirmationSignUpMessage = ""
        _ = Amplify.Auth.signIn(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let signInResult):
                    print("User successfully signed in \(signInResult)")
                if(signInResult.isSignedIn) {
                    DispatchQueue.main.async {
                        self?.scrubUiMessages()
                        self?.storeInKeychain(user: user, username: username, password: password)
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
    
    func scrubUiMessages() {
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
    
    func storeInKeychain(user: User, username: String, password: String) {
        user.id = self.getUserId()
        user.username = username
        user.password = password
        
        keychain.set(username, forKey: Keys.username, withAccess: KeychainSwiftAccessOptions.accessibleWhenUnlocked)
        keychain.set(password, forKey: Keys.password, withAccess: KeychainSwiftAccessOptions.accessibleWhenUnlocked)
        
        if(user.rememberMe) {
            keychain.set("true", forKey: Keys.rememberMe, withAccess: KeychainSwiftAccessOptions.accessibleWhenUnlocked)
        }
    }
    
    func getUsername() -> String {
        if(keychain.get(Keys.username) != nil) {
            return keychain.get(Keys.username) ?? ""
        } else {
            return ""
        }
    }
    
    func getPassword() -> String {
        if(keychain.get(Keys.password) != nil) {
            return keychain.get(Keys.password) ?? ""
        } else {
            return ""
        }
    }
    
    func getRememberMe() -> Bool {
        if(keychain.get(Keys.rememberMe) == "true") {
            return true
        } else {
            return false
        }
    }
    
    func setRememeberMe(user: User) {
        if(user.rememberMe) {
            keychain.set(user.rememberMe, forKey: Keys.rememberMe, withAccess: KeychainSwiftAccessOptions.accessibleWhenUnlocked)
        } else {
            keychain.delete(Keys.rememberMe)
            keychain.delete(Keys.username)
            keychain.delete(Keys.password)
        }
    }
}
