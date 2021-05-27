//
//  ConnectionsManager.swift
//  MyExp
//
//  Created by Johnson Liu on 7/14/20.
//  Copyright © 2020 Johnson Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ConnectionsManager: NSObject {
    
    //MARK: - APIs
    
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
    
    
    func saveDataFromUrl(url: String, parameters: [String: Any], completion: @escaping (_ data: Any) -> Void) {
        
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
