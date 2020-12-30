//
//  Equipment.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/30/20.
//

struct Equipment {
    var name: String
    var id: Int
    var imageName: String
    
    init(name: String = "wall ball", id: Int = -1, imageName: String = "wallball") {
        self.name = name
        self.id = id
        self.imageName = imageName
    }
    
    func toString() -> String {
        return "id = \(id), name = \(name), imageName = \(imageName)"
    }
}
