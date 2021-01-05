//
//  FavoriteEquipmentController.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/4/21.
//

import SwiftUI
import Amplify
import RxSwift

class FavoriteEquipmentController: UIViewController, ObservableObject {
    
    typealias JSONDictionary = [String : Any]
    
    func addFavoriteToUser(equipment: Equipment, userId: String, isFav: Bool){
        // This function call an API Gateway endpoint that calls a Lambda function
        // that stores the users favorite pieces of equipment
//        print("We need to toggle equipment \(equipment.name) with id \(equipment.id) for user \(userId).")
        let jsonDictionary: [String: String] = [
            "userId": "\(userId)",
            "equipmentId": "\(equipment.id)",
            "isFavorite": "\(isFav)"
        ]
        let dictAsString = asString(jsonDictionary: jsonDictionary)
        let request = RESTRequest(path: "/add-favorite", body: Data(dictAsString.utf8))
        _ = Amplify.API.put(request: request)
    }
    
    func getUsersFavoriteEquipment(userId: String) -> Observable<Array<String>> {
        // This function call an API Gateway endpoint that calls a Lambda function
        // that returns all the values in a DynamoDB table name user-equipment-favorites
        var allFavs = Array<String>();
        let request = RESTRequest(path: "/get-favorites/\(userId)")
        return Observable.create { observer in
            Amplify.API.get(request: request) { result in
                switch result {
                    case .success(let data):
                        do {
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,AnyObject>]
                            {
                                for eq in jsonArray {
                                    let isFav = eq["isFav"] as! String
                                    if(isFav == "true") {
                                        allFavs.append(eq["equipment.id"] as! String)
                                    }
                                }
                                observer.onNext(allFavs)
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
    
    func asString(jsonDictionary: JSONDictionary) -> String {
        // This function helps parse data being sent to API Gateway
      do {
        let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
      } catch {
        return ""
      }
    }
}
