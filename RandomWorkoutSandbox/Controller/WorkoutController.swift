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
import SwiftUI


class WorkoutController: UIViewController, ObservableObject {
    
    @Published public var inMemoryMovements:Array<Movement> = Array<Movement>();        // stores all the movements
    @Published public var inMemoryEquipmentList:Array<Equipment> = Array<Equipment>();  // stores all the pieces of equipment
    @Published public var inMemoryMovementsById:Array<Movement> = Array<Movement>();    // stores all the movements by a particular piece of equipment
    @Published public var randomMovement:String = ""                                    // stores the random movement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WorkoutController initialized...")
    }
    
    func getMovements() -> Observable<Array<Movement>> {
        // This function call an API Gateway endpoint that calls a Lambda function
        // that returns all the values in a DynamoDB table name ios-app-table
        var allMovements = Array<Movement>();
        let request = RESTRequest(path: "/movements")
        return Observable.create { observer in
            if(self.inMemoryMovements.count > 0) {
                // if the movements API call has already happened and been loaded
                observer.onNext(self.inMemoryMovements)
                return Disposables.create()
            }
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
                // get a random movement from all movements - currently not being used
                let numberOfMovements:Int = self.inMemoryMovements.count
                let randomIndex = Int.random(in: 0..<numberOfMovements)
                DispatchQueue.main.async {
                    self.randomMovement = self.inMemoryMovements[randomIndex].movement
                }
                observer.onNext(self.inMemoryMovements[randomIndex].movement)
            }
            else {
                // get a random movement from movements with equipmentId of whatever was passed in
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
    
    func getAllEquipmentList(favorites: Array<String>) {
        // This function builds out the original equipment list to display when app loads
        // it also passes in all of the users favorites and makes sure they are marked
        
        // break out of the function if the equipment list has already been built
        if(self.inMemoryEquipmentList.count > 0) {
            return
        }
        // Builds out the equipment list from all the movements
        var eqNameArray = Array<String>()
        var returnArray = Array<Equipment>()
        for movement in inMemoryMovements {
            if(!eqNameArray.contains(movement.equipment.name)) {
                eqNameArray.append(movement.equipment.name)
                let eq = Equipment(name: movement.equipment.name, id: movement.equipment.id, imageName: movement.equipment.imageName)
                returnArray.append(eq)
            }
        }
        
        // TODO Need to find a more optimal way of
        // looping through all equipment and marking them as favorites.
        for f in favorites {
            for e in returnArray {
                if(f == e.id) {
                    e.favorite = true
                }
            }
        }
        DispatchQueue.main.async {
            self.inMemoryEquipmentList = returnArray
        }
    }
    
    func getMovementsByEqId(_ id:String) -> Observable<Array<Movement>> {
        // Builds out a list of movements based on a particular equipment item the person chose
        return Observable.create { observer in
            if(self.inMemoryMovementsById.count > 0 && self.inMemoryMovementsById.first?.equipment.id == id) {
                // if the movements API call has already happened and been loaded
                observer.onNext(self.inMemoryMovementsById )
                return Disposables.create()
            }
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

