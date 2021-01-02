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


class WorkoutController: UIViewController, ObservableObject {
    
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
    
    @Published public var inMemoryMovements:Array<Movement> = Array<Movement>();
    @Published public var inMemoryEquipmentList:Array<Equipment> = Array<Equipment>();
    @Published public var inMemoryMovementsById:Array<Movement> = Array<Movement>();
    @Published public var randomMovement:String = ""
    
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
                                    newMovement.equipment.id = movement["equipment.id"] as! Int
                                    newMovement.equipment.name = movement["equipment.name"] as! String
                                    
                                    let imageName = newMovement.equipment.name.lowercased().replacingOccurrences(of: " ", with: "")
                                    newMovement.equipment.imageName = imageName
                                    
                                    newMovement.id = movement["id"] as! Int
                                    newMovement.movement = movement["movement"] as! String
                                    newMovement.difficulty = movement["difficulty"] as! Int
                                    newMovement.repType = movement["repType"] as! String
                                    newMovement.dynamic = movement["dynamic"] as! Bool
                                    
                                    allMovements.append(newMovement)
                                }
                                DispatchQueue.main.async {
                                    self.inMemoryMovements = allMovements
                                }
                                observer.onNext(allMovements)
                                observer.onCompleted()
                            } else {
                                print("Bad JSON error")
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

    func getRandomMovement(equipmentId: Int = -1) -> Observable<String> {
        print("get a random movement....")
        return Observable.create { observer in
            if(equipmentId == -1) {
                let numberOfMovements:Int = self.inMemoryMovements.count
                let randomIndex = Int.random(in: 0..<numberOfMovements)
                self.randomMovement = self.inMemoryMovements[randomIndex].movement
                observer.onNext(self.inMemoryMovements[randomIndex].movement)
            }
            else {
                self.getMovementsByEqId(equipmentId).subscribe(onNext: { theMovements in
                    let movementsByEqId:Array<Movement> = theMovements
                    let numberOfMovements:Int = movementsByEqId.count
                    let randomIndex = Int.random(in: 0..<numberOfMovements)
                    self.randomMovement = movementsByEqId[randomIndex].movement
                    observer.onNext(movementsByEqId[randomIndex].movement)
                })
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getAllEquipmentList() {
        var eqNameArray = Array<String>()
        var returnArray = Array<Equipment>()
        for movement in inMemoryMovements {
            if(!eqNameArray.contains(movement.equipment.name)) {
                eqNameArray.append(movement.equipment.name)
                let eq = Equipment(name: movement.equipment.name, id: movement.equipment.id, imageName: movement.equipment.imageName)
                returnArray.append(eq)
            }
        }
        DispatchQueue.main.async {
            self.inMemoryEquipmentList = returnArray
        }
    }
    
    func getMovementsByEqId(_ id:Int) -> Observable<Array<Movement>> {
        return Observable.create { observer in
            _ = self.getMovements().subscribe(onNext: { theMovements in
                var returnArray = Array<Movement>();
                for m in theMovements {
                    if(m.equipment.id == id) {
                        returnArray.append(m)
                    }
                }
                self.inMemoryMovementsById = returnArray
                observer.onNext(returnArray)
                
            })
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}

