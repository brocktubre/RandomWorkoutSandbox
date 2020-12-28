//
//  WorkoutController.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import Foundation
import UIKit

class WorkoutController: UIViewController {
    enum MovementDict: CaseIterable {
        case DUMBBELLS
        case BODYWEIGHT
        case GHD
        case WALL_TARGET
        case ROPE
        case JUMP_ROPE
        case PULLUP_BAR
        case BARBELL
        case RINGS
        case BOX
        case MACHINE
        case KETTLEBELL
    }
    
    func getMovements() -> Array<MovementObject> {
        print("Making HTTP request to get new workout.")
        
        var allMovements = Array<MovementObject>();
        let sem = DispatchSemaphore.init(value: 0)
        
        let numberOfEquipment = MovementDict.allCases.count
        for i in 0..<numberOfEquipment {
            let index = (i + 3)
            let url = URL(string: "https://spreadsheets.google.com/feeds/list/1maZYewAC_-u2jUNJki1O_7zbygB4HyTzXRkJBsnuguw/\(index)/public/values?alt=json")!
            
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                defer { sem.signal() }
                guard let data = data else { return }
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    if let feed = dictionary["feed"] as? [String: Any] {
                        if let entries = feed["entry"] as? [Any] {
                            for entry in entries {
                                let newMovement = MovementObject()
                                let resultNew = entry as? [String:Any]

                                // Get movement name
                                let movement = resultNew!["gsx$movement"] as? [String: Any]
                                let movementName = movement!["$t"] as? String
                                newMovement.movement = movementName ?? ""

                                // Get movement difficulty
                                let difficulty = resultNew!["gsx$difficulty"] as? [String: Any]
                                let difficultyVal = difficulty!["$t"] as? String
                                let difficultyValAsInt = Int(String(difficultyVal!))
                                newMovement.difficulty = difficultyValAsInt ?? -1

                                // Get movement repType
                                let repType = resultNew!["gsx$reptype"] as? [String: Any]
                                let repTypeVal = repType!["$t"] as? String

                                if(repTypeVal == "") {
                                    newMovement.repType = "number"
                                } else {
                                    newMovement.repType = repTypeVal!
                                }

                                // Get movement dynamic
                                let dynamic = resultNew!["gsx$dynamic"] as? [String: Any]
                                let dynamicVal = dynamic!["$t"] as? String
                                if(dynamicVal == "n"){
                                    newMovement.dynamic = false
                                } else {
                                    newMovement.dynamic = true
                                }
                                allMovements.append(newMovement)
                            }
                        }

                    }

                }
                
            };
            task.resume()
            sem.wait()
        }
        return allMovements
    }
}
