//
//  MovementObject.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import Foundation

class MovementObject {
    var movement: String = ""
    var difficulty: Int = -1
    var repType: String = "number"
    var dynamic: Bool = true
    var equipmentId: Int = -1
    var movementId: Int = -1
    var equipmentName: String = ""
    
    func toString() -> String {
        return "movementId = \(movementId), equimentId = \(equipmentId),  equimentName = \(equipmentName), movement = \(movement), difficulty =  \(difficulty), rep_type = \(repType), dynamic \(dynamic), "
    }
}
