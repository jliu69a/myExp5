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
    
    //MARK: - save changes
    
    func saveMyexpsWithParameters(parameters: [String: Any], completion: @escaping  (Any)->()) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/expenses_change.php", folder)
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.saveDataFromUrl(url: url, parameters: parameters) { (data: Any) in
            let myexpData: Data = data as! Data
            let myexpsList: [EditMyExpsData] = self.parseSaveMyexpsWithParameters(data: myexpData)
            let value: Any = myexpsList as Any
            completion(value)
        }
    }
    
    func parseSaveMyexpsWithParameters(data: Data) -> [EditMyExpsData] {
        
        let json = try? JSON(data: data)
        if json == nil {
            print("- my expenses : No Data")
            return []
        }
        
        var dataList: [EditMyExpsData] = []
        do {
            dataList = try JSONDecoder().decode([EditMyExpsData].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }
    
    //MARK: - save payment / vendor
    
    func savePaymentsAndVendors(parameters: [String: Any], completion: @escaping  (Any)->()) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/payments_vendors_edit.php", folder)
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.saveDataFromUrl(url: url, parameters: parameters) { (data: Any) in
            let myexpData: Data = data as! Data
            let myexpsList: [ChangePVData] = self.parseSavePaymentsAndVendors(data: myexpData)
            let value: Any = myexpsList as Any
            completion(value)
        }
    }
    
    func parseSavePaymentsAndVendors(data: Data) -> [ChangePVData] {
        
        let json = try? JSON(data: data)
        if json == nil {
            print("- my expenses : No Data")
            return []
        }
        
        var dataList: [ChangePVData] = []
        do {
            dataList = try JSONDecoder().decode([ChangePVData].self, from: data)
        }
        catch {
            print(error)
        }
        
        return dataList
    }
    
    //MARK: - vendor lookup
    
    func vendorsLookup(year: String, vendorId: String, completion: @escaping  (Any)->()) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/vendors_lookup.php?year=%@&vendorid=%@", folder, year, vendorId)
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            let myexpData: Data = data as! Data
            let myexpsList: [MyExpsData] = self.parseDataForVendors(data: myexpData)
            let value: Any = myexpsList as Any
            completion(value)
        }
    }
    
    func parseDataForVendors(data: Data) -> [MyExpsData] {
        
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
    
    //MARK: - expense lookup
    
    func expenseLookup(year: String, month: String, completion: @escaping  (Any)->()) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/expense_lookup.php?date=%@-%@", folder, year, month)
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            let myexpData: Data = data as! Data
            let myexpsList: [Expense] = self.parseDataForExpenseLookup(data: myexpData)
            let value: Any = myexpsList as Any
            completion(value)
        }
    }

    func parseDataForExpenseLookup(data: Data) -> [Expense] {
        
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
    
    //MARK: - save home test
    
    func saveHomeTest(data: HomeTest) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/change_home_test.php", folder)
        let connect: ConnectionsManager = ConnectionsManager()

        connect.saveHomeTestData(url: url, data: data) { (data: Any) in
            let myexpData: Data = data as! Data
            
            let resultText: String = String(data: myexpData, encoding: .utf8) ?? "n/a"
            print("- ")
            print("- save HomeTest, result = '\(resultText)' ")
            print("- ")
        }
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
