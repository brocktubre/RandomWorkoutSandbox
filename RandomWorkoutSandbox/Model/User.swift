//
//  User.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/6/21.
//
import RxSwift

class User: ObservableObject {
    var username: String
    var id: String
    var password: String
    @Published var rememberMe: Bool
    
    init(username: String = "", id: String = "", rememberMe: Bool = false, password: String = "") {
        self.username = username
        self.id = id
        self.rememberMe = rememberMe
        self.password = password
    }
    
    func toString() -> String {
        return "id = \(id), username = \(username), password = \(getPasswordHidden(password: password)), rememberMe = \(rememberMe)"
    }
    
    func getPasswordHidden(password: String) -> String {
        var hiddenPassword = ""
        for _ in password {
            hiddenPassword += "*"
        }
        return hiddenPassword
    }
}
