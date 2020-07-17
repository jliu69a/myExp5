//
//  DatasManager.swift
//  MyTest6
//
//  Created by Johnson Liu on 7/14/20.
//  Copyright © 2020 Johnson Liu. All rights reserved.
//

import UIKit
import SwiftyJSON


class DatasManager: NSObject {
    
    static let sharedInstance = DatasManager()
    
    let folder: String = "homee" //production use
    let kExpenseCode: Int = 0
    let kTop10Code: Int = 1
    let kPaymentCode: Int = 2
    let kVendorCode: Int = 3
    
    
    //MARK: - myexp preload data
    
    func myExpsData(selectedDate: Date, completion: @escaping  (Any)->()) {
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateStr: String = df.string(from: selectedDate)
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/preload_data.php?date=%@", folder, dateStr)
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            let myexpData: Data = data as! Data
            let myexpsList: [MyExpsData] = self.parseMyExpsData(data: myexpData)
            let value: Any = myexpsList as Any
            completion(value)
        }
    }
    
    func parseMyExpsData(data: Data) -> [MyExpsData] {
        
        let json = try? JSON(data: data)
        if json == nil {
            print("- my expenses : No Data")
            return []
        }
        
        var dataList: [MyExpsData] = []
        do {
            dataList = try JSONDecoder().decode([MyExpsData].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }
    
    //MARK: - myexp by date
    
    func myExpsWithDate(selectedDate: Date, completion: @escaping  (Any)->()) {
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateStr: String = df.string(from: selectedDate)
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/expense_by_date.php?date=%@", folder, dateStr)
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            let myexpData: Data = data as! Data
            let myexpsList: [Expense] = self.parseMyExpsWithDate(data: myexpData)
            let value: Any = myexpsList as Any
            completion(value)
        }
    }
    
    func parseMyExpsWithDate(data: Data) -> [Expense] {
        
        let json = try? JSON(data: data)
        if json == nil {
            print("- my expenses : No Data")
            return []
        }
        
        var dataList: [Expense] = []
        do {
            dataList = try JSONDecoder().decode([Expense].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }
    
    //MARK: - states data
    
    func statesData(completion: @escaping  (Any)->()) {
        
        let url: String = "http://www.mysohoplace.com/php_hdb/home_test/all_states.php"
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            let statesData: Data = data as! Data
            let statesList: [StatesData] = self.parseStatesData(data: statesData)
            let value: Any = statesList as Any
            completion(value)
        }
    }

    func parseStatesData(data: Data) -> [StatesData] {
        
        let json = try? JSON(data: data)
        if json == nil {
            print("- states : No Data")
            return []
        }
        
        var dataList: [StatesData] = []
        do {
            dataList = try JSONDecoder().decode([StatesData].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }

}
