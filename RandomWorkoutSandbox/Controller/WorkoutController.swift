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
        case SANDBAG
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
    
    let OFFSET:Int = 3
    public var inMemoryMovements:Array<Movement> = Array<Movement>();
    
    // This function returns all the movements as an array of MovementObjects
    func getMovements() -> Array<Movement> {
        print("Making HTTP request to get new workout.")
        
        var allMovements = Array<Movement>();
        let sem = DispatchSemaphore.init(value: 0)
        var eqNameG:String = ""
        
        let numberOfEquipment = MovementDict.allCases.count
        for i in 0..<numberOfEquipment {
            let index = (i + OFFSET)
            let url = URL(string: "https://spreadsheets.google.com/feeds/list/1maZYewAC_-u2jUNJki1O_7zbygB4HyTzXRkJBsnuguw/\(index)/public/values?alt=json")!
            
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                defer { sem.signal() }
                guard let data = data else { return }
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    if let feed = dictionary["feed"] as? [String: Any] {
                        if let title = feed["title"] as? [String: Any] {
                            if let eqName = title["$t"] as? String {
                                eqNameG = eqName
                            }
                        }
                        if let entries = feed["entry"] as? [Any] {
                            for entry in entries {
                                let newMovement = Movement(equipment: Equipment())
                                newMovement.equipment.id = index // set the parent equipment ID
                                newMovement.equipment.name = eqNameG
                                
                                let resultNew = entry as? [String:Any]
                                
                                // Get movement name
                                let movement = resultNew!["gsx$movement"] as? [String: Any]
                                let movementName = movement!["$t"] as? String
                                newMovement.movement = movementName ?? ""
                                
                                // Get equipmentName name
//                                let eqName = resultNew!["gsx$movement"] as? [String: Any]
//                                let eqNameVal = eqName!["$t"] as? String
//                                newMovement.equipmentName = eqNameVal ?? ""
                                

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
        // set the IDs for the movments
        var index:Int = 0
        for m in allMovements {
            m.id = index;
            index += 1
        }
        inMemoryMovements = allMovements
        return allMovements
    }
    
    func getRandomMovement(_ allMovements:Array<Movement>) -> String {
            let numberOfMovements:Int = allMovements.count
            let randomIndex = Int.random(in: 0..<numberOfMovements)
            return allMovements[randomIndex].movement
    }
    
    func getAllEquipmentList() -> Array<String> {
        var returnArray = Array<String>()
        returnArray.append("All")
        let allm = getMovements()
        for eqName in allm {
            if(!returnArray.contains(eqName.equipment.name)) {
                returnArray.append(eqName.equipment.name)
            }
        }
        return returnArray
    }
    
    func getMovementsByEqId(_ id:Int) -> Array<Movement> {
        
        var theMovements = Array<Movement>();
        let sem = DispatchSemaphore.init(value: 0)
        
        let url = URL(string: "https://spreadsheets.google.com/feeds/list/1maZYewAC_-u2jUNJki1O_7zbygB4HyTzXRkJBsnuguw/\(id)/public/values?alt=json")!
        
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            defer { sem.signal() }
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Any] {
                if let feed = dictionary["feed"] as? [String: Any] {
                    if let entries = feed["entry"] as? [Any] {
                        for entry in entries {
                            let eq = Equipment()
                            let newMovement = Movement(equipment: eq)
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
                            theMovements.append(newMovement)
                        }
                    }

                }

            }
            
        };
        task.resume()
        sem.wait()
        return theMovements
    }
    
}

