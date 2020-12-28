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
    
    func toString() -> String {
        return "movement = \(movement), difficulty =  \(difficulty), rep_type = \(repType), dynamic \(dynamic)"
    }
}
