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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WorkoutController initialized...")
    }
    
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
                                    newMovement.equipment.id = movement["equipment.id"] as! String
                                    newMovement.equipment.name = movement["equipment.name"] as! String
                                    
                                    let imageName = newMovement.equipment.name.lowercased().replacingOccurrences(of: " ", with: "")
                                    newMovement.equipment.imageName = imageName
                                    
                                    newMovement.id = movement["id"] as! String
                                    newMovement.movement = movement["movement"] as! String
                                    newMovement.difficulty = movement["difficulty"] as! Int
                                    newMovement.repType = movement["repType"] as! String
                                    newMovement.dynamic = movement["dynamic"] as! Bool
                                    
                                    allMovements.append(newMovement)
                                }
                                DispatchQueue.main.async {
                                    self.inMemoryMovements = allMovements
                                }
                                print("Total number of movements loaded into memory: \(allMovements.count)")
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

    func getRandomMovement(equipmentId: String?) -> Observable<String> {

        return Observable.create { observer in
            print("get a random movement....")
            if(equipmentId == nil) {
                let numberOfMovements:Int = self.inMemoryMovements.count
                let randomIndex = Int.random(in: 0..<numberOfMovements)
                DispatchQueue.main.async {
                    self.randomMovement = self.inMemoryMovements[randomIndex].movement
                }
                observer.onNext(self.inMemoryMovements[randomIndex].movement)
            }
            else {
                let movementsByEqId:Array<Movement> = self.inMemoryMovementsById
                let numberOfMovements:Int = movementsByEqId.count
                let randomIndex = Int.random(in: 0..<numberOfMovements)
                DispatchQueue.main.async {
                    self.randomMovement = movementsByEqId[randomIndex].movement
                }
                observer.onNext(movementsByEqId[randomIndex].movement)
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
    
    func getMovementsByEqId(_ id:String) -> Observable<Array<Movement>> {
        return Observable.create { observer in
            var returnArray = Array<Movement>();
            for m in self.inMemoryMovements {
                if(m.equipment.id == id) {
                    returnArray.append(m)
                }
            }
            DispatchQueue.main.async {
                self.inMemoryMovementsById = returnArray
            }
            observer.onNext(returnArray)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}

