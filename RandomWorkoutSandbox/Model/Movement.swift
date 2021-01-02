//
//  MovementObject.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//
class Movement {
    var movement: String
    var difficulty: Int
    var repType: String
    var dynamic: Bool
    var equipment: Equipment
    var id: String
    
    init(   movement: String = "wall balls",
            difficulty: Int = -1,
            repType: String = "number",
            dynamic: Bool = true,
            equipment: Equipment,
            id: String = "-1") {
        
        self.movement = movement
        self.difficulty = difficulty
        self.repType = repType
        self.dynamic = dynamic
        self.id = id
        self.equipment = Equipment(name: "wall ball", id: "-1", imageName: "wallball")
    }
    
    func toString() -> String {
        return "movementId = \(id), equimentId = \(equipment.id),  equipmentName = \(equipment.name), equipmentImageName = \(equipment.imageName), movement = \(movement), difficulty =  \(difficulty), rep_type = \(repType), dynamic \(dynamic), "
    }
}
