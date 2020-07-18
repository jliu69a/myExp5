//
//  ConnectionsManager.swift
//  MyTest6
//
//  Created by Johnson Liu on 7/14/20.
//  Copyright © 2020 Johnson Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ConnectionsManager: NSObject {
    
    func getJsonFromUrl(url: String, completion: @escaping (_ json: JSON) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case let .success(value):
                if let json = JSON(rawValue: value) {
                    completion(json)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getDataFromUrl(url: String, completion: @escaping (_ data: Any) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case let .success(value):
                completion(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func saveHomeTestData(url: String, data: HomeTest, completion: @escaping (_ data: Any) -> Void) {
        
//        AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default).responseData { response in
//            switch response.result {
//            case let .success(value):
//                completion(value)
//            case let .failure(error):
//                print(error)
//            }
//        }
        
        let parameters: [String: Any] = ["name": ("to save 2" as Any), "value": ("testing data 2" as Any), "notes": ("call from app 2" as Any)]
        AF.request(url, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).validate().responseData { response in
            switch response.result {
            case let .success(value):
                completion(value)
            case let .failure(error):
                print(error)
            }
        }
        
        
    }
    
}
