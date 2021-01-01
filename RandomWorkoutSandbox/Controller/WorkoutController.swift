//
//  WorkoutController.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import Foundation
import UIKit
import Amplify
import Combine
import RxSwift


class WorkoutController: UIViewController {
    enum MovementDict: CaseIterable {
        case DUMBBELL
        case BODYWEIGHT
        case SANDBAG
        case GHD
        case WALL
        case WALLBALL
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
    
//    func callLambdaFunc() -> String {
//        print("We are attempting to use Amplify to call Lambda...")
//        var request = RESTRequest()
//        Amplify.API.get(request: <#T##RESTRequest#>)
//
//
//    }
    
    func getMovements() -> Observable<Array<Movement>> {
        
        var allMovements = Array<Movement>();
        
        let request = RESTRequest(path: "/movements")
        return Observable.create { observer in
            Amplify.API.get(request: request) { [self] result in
                switch result {
                    case .success(let data):
                        do {
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,AnyObject>]
                            {
                                for movement in jsonArray {
                                    let newMovement = Movement(equipment: Equipment())
                                    // newMovement.equipment.id = movement["id"] as! Int
                                    newMovement.equipment.name = movement["equipment"] as! String
                                    
                                    newMovement.id = movement["id"] as! Int
                                    newMovement.movement = movement["movement"] as! String
                                    newMovement.difficulty = movement["difficulty"] as! Int
                                    newMovement.repType = movement["repType"] as! String
                                    newMovement.dynamic = movement["dynamic"] as! Bool
                                    
                                    allMovements.append(newMovement)
                                }
                                var index:Int = 0
                                for m in allMovements {
                                   m.id = index;
                                   index += 1
                                }
                                inMemoryMovements = allMovements
                                observer.onNext(allMovements)
                                observer.onCompleted()
                            } else {
                                print("Bad JSON")
                            }
                        } catch let error as NSError {
                            observer.onError(error)
                        }

                    case .failure(let apiError):
                        observer.onError(apiError)
                    }
            }
            return Disposables.create()
        }
        
    }
    
//     This function returns all the movements as an array of MovementObjects
//    func getMovements() -> Array<Movement> {
//        callLambdaFunc()
//        print("Making HTTP request to get all movements (building dataset).")
//
//        var allMovements = Array<Movement>();
//        let sem = DispatchSemaphore.init(value: 0)
//        var eqNameG:String = ""
//
//        let numberOfEquipment = MovementDict.allCases.count
//        for i in 0..<numberOfEquipment {
//            let index = (i + OFFSET)
//            let url = URL(string: "https://spreadsheets.google.com/feeds/list/1maZYewAC_-u2jUNJki1O_7zbygB4HyTzXRkJBsnuguw/\(index)/public/values?alt=json")!
//
//
//            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//                defer { sem.signal() }
//                guard let data = data else { return }
//                let json = try? JSONSerialization.jsonObject(with: data, options: [])
//                if let dictionary = json as? [String: Any] {
//                    if let feed = dictionary["feed"] as? [String: Any] {
//                        if let title = feed["title"] as? [String: Any] {
//                            if let eqName = title["$t"] as? String {
//                                eqNameG = eqName
//                            }
//                        }
//                        if let entries = feed["entry"] as? [Any] {
//                            for entry in entries {
//                                let newMovement = Movement(equipment: Equipment())
//                                newMovement.equipment.id = index // set the parent equipment ID
//                                newMovement.equipment.name = eqNameG
//
//                                let resultNew = entry as? [String:Any]
//
//                                // Get movement name
//                                let movement = resultNew!["gsx$movement"] as? [String: Any]
//                                let movementName = movement!["$t"] as? String
//                                newMovement.movement = movementName ?? ""
//
//                                // Get equipmentName name
////                                let eqName = resultNew!["gsx$movement"] as? [String: Any]
////                                let eqNameVal = eqName!["$t"] as? String
////                                newMovement.equipmentName = eqNameVal ?? ""
//
//
//                                // Get movement difficulty
//                                let difficulty = resultNew!["gsx$difficulty"] as? [String: Any]
//                                let difficultyVal = difficulty!["$t"] as? String
//                                let difficultyValAsInt = Int(String(difficultyVal!))
//                                newMovement.difficulty = difficultyValAsInt ?? -1
//
//                                // Get movement repType
//                                let repType = resultNew!["gsx$reptype"] as? [String: Any]
//                                let repTypeVal = repType!["$t"] as? String
//
//                                if(repTypeVal == "") {
//                                    newMovement.repType = "number"
//                                } else {
//                                    newMovement.repType = repTypeVal!
//                                }
//
//                                // Get movement dynamic
//                                let dynamic = resultNew!["gsx$dynamic"] as? [String: Any]
//                                let dynamicVal = dynamic!["$t"] as? String
//                                if(dynamicVal == "n"){
//                                    newMovement.dynamic = false
//                                } else {
//                                    newMovement.dynamic = true
//                                }
//                                allMovements.append(newMovement)
//                            }
//                        }
//
//                    }
//
//                }
//
//            };
//            task.resume()
//            sem.wait()
//        }
//        // set the IDs for the movments
//        var index:Int = 0
//        for m in allMovements {
//            m.id = index;
//            index += 1
//        }
//        inMemoryMovements = allMovements
//        return allMovements
//    }

    func getRandomMovement(equipmentId: Int = -1) -> String {
        if(equipmentId == -1) {
            let numberOfMovements:Int = inMemoryMovements.count
            let randomIndex = Int.random(in: 0..<numberOfMovements)
            return inMemoryMovements[randomIndex].movement
        }
        else {
            let movementsByEqId:Array<Movement> = getMovementsByEqId(equipmentId)
            let numberOfMovements:Int = movementsByEqId.count
            let randomIndex = Int.random(in: 0..<numberOfMovements)
            return movementsByEqId[randomIndex].movement
        }
    }
    
    func getAllEquipmentList() -> Array<Equipment> {
        var eqNameArray = Array<String>()
        var returnArray = Array<Equipment>()
        self.getMovements().subscribe(onNext: { allMovements in
            for movement in allMovements {
                if(!eqNameArray.contains(movement.equipment.name)) {
                    eqNameArray.append(movement.equipment.name)
                }
            }
            var index:Int = 0
            for eq in eqNameArray {
                let e = Equipment(name: eq,
                                  id: index,
                                  imageName: eq.lowercased().replacingOccurrences(of: " ", with: ""))
                returnArray.append(e)
                index += 1
            }
        })
        return returnArray
    }
    
    func getMovementsByEqId(_ id:Int) -> Array<Movement> {
        
        let equipmentId = id + OFFSET
        var theMovements = Array<Movement>();
        let sem = DispatchSemaphore.init(value: 0)
        
        let url = URL(string: "https://spreadsheets.google.com/feeds/list/1maZYewAC_-u2jUNJki1O_7zbygB4HyTzXRkJBsnuguw/\(equipmentId)/public/values?alt=json")!
        
        
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

