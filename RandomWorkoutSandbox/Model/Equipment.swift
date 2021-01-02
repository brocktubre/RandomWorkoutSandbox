//
//  Equipment.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/30/20.
//

import Combine

class Equipment: ObservableObject {
    
    var name: String
    var id: String
    var imageName: String
    @Published var favorite: Bool
    
    init(name: String = "wall ball", id: String = "-1", imageName: String = "wallball", favorite: Bool = false) {
        self.name = name
        self.id = id
        self.imageName = imageName
        self.favorite = favorite
    }
    
    func toString() -> String {
        return "id = \(id), name = \(name), imageName = \(imageName), favorite = \(favorite)"
    }
}

extension Equipment: Hashable, Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Equipment: Equatable {
    static func == (lhs: Equipment, rhs: Equipment) -> Bool {
        lhs === rhs
    }
}
