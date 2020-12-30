//
//  Equipment.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/30/20.
//

struct Equipment {
    var name: String
    var id: Int
    
    init(name: String = "wall ball", id: Int = -1) {
        self.name = name
        self.id = id
    }
    
    func toString() -> String {
        return "name = \(name), id = \(id)"
    }
}
