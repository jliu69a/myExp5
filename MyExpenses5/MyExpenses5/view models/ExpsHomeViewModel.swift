//
//  ExpsHomeViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/6/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol ExpsHomeViewModelDelegate: class {
    func didLoadExpensesData()
}


class ExpsHomeViewModel {
    
    let kInsertCode: Int = 1
    let kUpdateCode: Int = 2
    let kDeleteCode: Int = 3
    
    weak var delegate: ExpsHomeViewModelDelegate?
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    var totalSections: Int = 1
    var totalRows: Int = 0
    
    var expenseList: [Expense] = []
    var totalAmount: Double = 0
}

extension ExpsHomeViewModel {
    
    //MARK: - table view data
    
    func numberOfSectionis() -> Int {
        return self.totalSections
    }
    
    func numberOfRows(index: Int) -> Int {
        return self.totalRows
    }
    
    func rowAtIndex(index: Int) -> Expense? {
        
        if index >= self.expenseList.count {
            return nil
        }
        return self.expenseList[index]
    }
    
    func displayTotalAmount() -> String {
        return String(format: "Total($): %0.2f", self.totalAmount)
    }
    
    func displayCurrentDate(date: Date) -> String {
        return date.dateToText(formate: "yyyy-MM-dd, EEE")
    }
    
    //MARK: - api, query expense
    
    func loadingData(date: Date) {
        loadingMyExpenses(selectedDate: date) {}
    }
    
    func loadingMyExpenses(selectedDate: Date, completion: @escaping () -> Void) {
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/preload_data.php?date=%@", self.appDele.folder, selectedDate.dateToText(formate: "yyyy-MM-dd"))
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.getDataFromUrl(url: url) { [weak self] (data: Any) in
            let myexpData: Data = data as! Data
            let myexpsList: [MyExpsData] = self?.myExpensesData(data: myexpData) ?? []
            self?.parseMyExpsData(myexpsList: myexpsList)
            completion()
        }
    }

    func myExpensesData(data: Data) -> [MyExpsData] {
        
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
    
    //MARK: - parse json
    
    func parseMyExpsData(myexpsList: [MyExpsData]) {
        clearAllData()

        for each in myexpsList {
            if each.expense != nil {
                self.expenseList = each.expense!
            }
            if each.payments != nil {
                self.appDele.paymentsList = each.payments!
            }
            if each.vendors != nil {
                self.appDele.vendorsList = each.vendors!
            }
            if each.top10 != nil {
                self.appDele.top10sList = each.top10!
            }
        }
        self.totalRows = self.expenseList.count
        
        parseVendorsArray()
        totalExpensesAmount()
        self.delegate?.didLoadExpensesData()
    }
    
    func parseSavedExpsData(myexpsList: [EditMyExpsData]) {
        
        self.expenseList.removeAll()
        self.appDele.top10sList.removeAll()
        
        for each in myexpsList {
            if each.expense != nil {
                self.expenseList = each.expense!
            }
            if each.top10 != nil {
                self.appDele.top10sList = each.top10!
            }
        }
        self.totalRows = self.expenseList.count
        
        parseVendorsArray()
        totalExpensesAmount()
        self.delegate?.didLoadExpensesData()
    }
    
    func parseVendorsArray() {
        let vendorsList = self.appDele.vendorsList
        
        if vendorsList.count == 0 {
            return
        }
        
        let top10Key: String = "Top 10"
        self.appDele.vendorDisplayTitles.append(top10Key)
        self.appDele.vendorDisplayData[top10Key] = self.appDele.top10sList as AnyObject
        
        let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        for each in vendorsList {
            let vendorName: String = each.vendor!.uppercased()
            
            var firstLetter: String = String(vendorName.prefix(1))
            if letters.contains(firstLetter) == false {
                firstLetter = "#"
            }
            
            if self.appDele.vendorDisplayTitles.contains(firstLetter) == false {
                self.appDele.vendorDisplayTitles.append(firstLetter)
            }
            var vendorsArray = (self.appDele.vendorDisplayData[firstLetter] as? [Vendor]) ?? []
            
            let isUnique = self.checkForUnique(vendorsList: vendorsArray, vendor: each)
            if isUnique {
                vendorsArray.append(each)
            }
            self.appDele.vendorDisplayData[firstLetter] = vendorsArray as AnyObject
        }
        
        //-- test print
        print("> ")
        print("> total top 10s (in AppDelegate) = \(self.appDele.top10sList.count)")
        print("> total vendors (in AppDelegate) = \(self.appDele.vendorsList.count)")
        print("> total payments (in AppDelegate) = \(self.appDele.paymentsList.count)")
        print("> total expenses = \(self.expenseList.count)")
        print("- ")
        let array: [Vendor] = self.appDele.vendorDisplayData[top10Key] as? [Vendor] ?? []
        for each in array {
            let name = each.vendor ?? ""
            let id = each.id ?? "0"
            let total = each.total ?? "0"
            print("    - top 10, id = \(id), total = \(total), name = \(name)")
        }
        print("- ")
    }
    
    func checkForUnique(vendorsList: [Vendor], vendor: Vendor) -> Bool {
        
        if vendorsList.count == 0 {
            return true
        }
        var isUnique: Bool = true
        
        for each in vendorsList {
            let eachId = each.id ?? "0"
            let vendorId = vendor.id ?? "0"
            
            if eachId == vendorId {
                isUnique = false
                break
            }
        }
        return isUnique
    }
    
    //MARK: - api, save expense
    
    func savingData(data: Expense, actionCode: Int) {
        saveMyexpsWithParameters(data: data, actionCode: actionCode) {}
    }
    
    func saveMyexpsWithParameters(data: Expense, actionCode: Int, completion: @escaping () -> Void) {
        
        let parameters: [String: Any] = self.createParameters(data: data, actionCode: actionCode)
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/expenses_change.php", self.appDele.folder)
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.saveDataFromUrl(url: url, parameters: parameters) { [weak self] (data: Any) in
            let myexpData: Data = data as! Data
            let myexpsList: [EditMyExpsData] = self?.parseSaveMyexpsWithParameters(data: myexpData) ?? []
            self?.parseSavedExpsData(myexpsList: myexpsList)
            completion()
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
    
    func createParameters(data: Expense, actionCode: Int) -> [String: Any] {
        
        let currentDate: String = Date().dateToText(formate: "yyyy-MM-dd")
        let currentTime: String = Date().dateToText(formate: "HH:mm:ss")
        
        let id: String = data.id ?? "-1"
        let date: String = data.date ?? currentDate
        let time: String = data.time ?? currentTime
        let vendorId: String = data.vendor_id ?? "0"
        let paymentId: String = data.payment_id ?? "0"
        let amount: String = data.amount ?? "0"
        let note: String = data.note ?? ""
        
        var isEdit: String = "0"
        switch actionCode {
        case kInsertCode:
            isEdit = "0"
            break
        case kUpdateCode:
            isEdit = "1"
            break
        case kDeleteCode:
            isEdit = "0"
            break
        default:
            break
        }
        
        let parameters: [String: Any] = ["id": (id as Any), "date": (date as Any), "time": (time as Any), "vendorid":(vendorId as Any), "paymentid":(paymentId as Any), "amount":(amount as Any), "note":(note as Any), "isedit":(isEdit as Any)]
        
        return parameters
    }
    
    //MARK: - helpers
    
    func clearAllData() {
        
        self.expenseList.removeAll()
        self.appDele.paymentsList.removeAll()
        self.appDele.vendorsList.removeAll()
        self.appDele.top10sList.removeAll()
        
        self.appDele.vendorDisplayTitles.removeAll()
        self.appDele.vendorDisplayData.removeAll()
    }
    
    func totalExpensesAmount() {
        self.totalAmount = 0
        
        if self.expenseList.count == 0 {
            return
        }
        
        for each in self.expenseList {
            let amount = Double(each.amount ?? "0") ?? 0
            self.totalAmount += amount
        }
    }
}
