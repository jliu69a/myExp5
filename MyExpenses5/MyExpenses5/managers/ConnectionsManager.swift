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
    
    func saveDataFromUrl(url: String, completion: @escaping (_ data: Any) -> Void) {
        
        AF.request(url).responseData { response in
            switch response.result {
            case let .success(value):
                completion(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
