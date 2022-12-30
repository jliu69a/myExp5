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
        
//        AF.request(url, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).validate().responseData { response in
//            switch response.result {
//            case let .success(value):
//                completion(value)
//            case let .failure(error):
//                print(error)
//            }
//        }
        
        print("> connect manager, parameters : \(parameters)")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        let urlLink = URL(string: url)!
        
        //-- error: parameters not passing in.

        var request = URLRequest(url: urlLink)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("> saveDataFromUrl has error : \(error?.localizedDescription ?? "")")
                return
            }

            guard let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("> responseJson has problem.")
                return
            }
            completion(responseJson)
        }
        task.resume()
    }
    
    func saveData2FromUrl(url: String, completion: @escaping (_ data: Any) -> Void) {
        
        AF.request(url).responseData { response in
            switch response.result {
            case let .success(value):
                completion(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    //MARK: - testing
    
    func saveHomeTestData(url: String, data: HomeTest, completion: @escaping (_ data: Any) -> Void) {
        
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
