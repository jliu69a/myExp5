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
    
    let folder: String = (UIApplication.shared.delegate as! AppDelegate).folder
    let kExpenseCode: Int = 0
    let kTop10Code: Int = 1
    let kPaymentCode: Int = 2
    let kVendorCode: Int = 3
    
    
    //MARK: - unit testing
    
    var testDataString = ""
    
    func testingForData(urlString: String) {
        let connect: ConnectionsManager = ConnectionsManager()
        connect.getDataFromUrl(url: urlString) { (data: Any) in
            let rawData: Data = data as! Data
            self.testDataString = String(decoding: rawData, as: UTF8.self)
        }
    }
    
    //MARK: - myexp preload data
    
    func myExpsData(selectedDate: Date, completion: @escaping  (Data)->()) {
        
        let dateStr: String = selectedDate.dateToText(formate: "yyyy-MM-dd")
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/preload_data.php?date=%@", folder, dateStr)
        let connect: ConnectionsManager = ConnectionsManager()
        print("-> DatasManager, myExpsData(), URL : \(url)")
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            let myexpData: Data = data as! Data
            completion(myexpData)
        }
    }

    func parseMyExpsData(data: Data) -> [MyExpsData] {
        
        guard let _ = try? JSON(data: data) else {
            print("ERROR: myExpsData, response has error.")
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
        
        let dateStr: String = selectedDate.dateToText(formate: "yyyy-MM-dd")
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/expense_by_date.php?date=%@", folder, dateStr)
        let connect: ConnectionsManager = ConnectionsManager()
        print("-> DatasManager, myExpsWithDate(), URL : \(url)")
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                let myexpsList: [Expense] = self.parseMyExpsWithDate(data: rawData)
                let value: Any = myexpsList as Any
                completion(value)
            }
        }
    }
    
    func parseMyExpsWithDate(data: Data) -> [Expense] {
        
        guard let _ = try? JSON(data: data) else {
            print("ERROR: myExpsWithDate, response has error.")
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
    
    func saveMyexpsWithParameters(paraString: String, completion: @escaping  (Data)->()) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/expenses_change.php?%@", folder, paraString)
        let connect: ConnectionsManager = ConnectionsManager()
        print("-> DatasManager, saveMyExps2WithParameters(), URL string : \(url)")
        
        connect.saveDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                completion(rawData)
            }
        }
    }
    
    //MARK: - save payment / vendor
    
    func saveForPaymentsAndVendors(paramString: String, completion: @escaping  (Data)->()) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/payments_vendors_edit.php?%@", folder, paramString)
        let connect: ConnectionsManager = ConnectionsManager()
        print("-> DatasManager, save2ForPaymentsAndVendors(), URL : \(url)")
        
        connect.saveDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                completion(rawData)
            }
        }
    }
    
    //MARK: - vendor lookup
    
    func vendorsLookup(year: String, vendorId: String, completion: @escaping  (Any)->()) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/vendors_lookup.php?year=%@&vendorid=%@", folder, year, vendorId)
        let connect: ConnectionsManager = ConnectionsManager()
        print("-> DatasManager, vendorsLookup(), URL : \(url)")
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                let myexpsList: [MyExpsData] = self.parseDataForVendors(data: rawData)
                let value: Any = myexpsList as Any
                completion(value)
            }
        }
    }
    
    func parseDataForVendors(data: Data) -> [MyExpsData] {
        
        guard let _ = try? JSON(data: data) else {
            print("ERROR: vendorsLookup, response has error.")
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
        print("-> DatasManager, expenseLookup(), URL : \(url)")
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                let myexpsList: [Expense] = self.parseDataForExpenseLookup(data: rawData)
                let value: Any = myexpsList as Any
                completion(value)
            }
        }
    }

    func parseDataForExpenseLookup(data: Data) -> [Expense] {
        
        guard let _ = try? JSON(data: data) else {
            print("ERROR: expenseLookup, response has error.")
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
    
    //MARK: - film data
    
    func loadFilmsData(completion: @escaping  (Data)->()) {
        
        let url: String = "http://www.mysohoplace.com/php_hdb/php_Film_List/preload_film_data.php"
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { (data: Any) in
            if let rawData = data as? Data {
                completion(rawData)
            }
        }
    }
    
}
