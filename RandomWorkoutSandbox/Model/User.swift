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
    @Published var rememberMe: Bool
    
    init(username: String = "", id: String = "", rememberMe: Bool = false) {
        self.username = username
        self.id = id
        self.rememberMe = rememberMe
    }
    
    func toString() -> String {
        return "id = \(id), username = \(username), rememberMe = \(rememberMe)"
    }
}
