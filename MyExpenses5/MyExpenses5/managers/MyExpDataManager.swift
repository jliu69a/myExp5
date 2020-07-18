//
//  MyExpDataManager.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/16/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class MyExpDataManager: NSObject {
    
    static let sharedInstance = MyExpDataManager()
    
    let kInsertCode: Int = 1
    let kUpdateCode: Int = 2
    let kDeleteCode: Int = 3
    
    var totalSections: Int = 0
    var expenseList: [Expense] = []
    var paymentList: [Payment] = []
    var vendorList: [Vendor] = []
    var top10List: [Top10] = []
    
    //MARK: - util functions
    
    func showDate(date: Date?) -> String {
        
        var selectedDate: Date? = date
        if selectedDate == nil {
            selectedDate = Date()
        }
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd, E"
        let dateText: String = df.string(from: selectedDate!)
        
        return dateText
    }
    
    func createParameters(data: Expense, actionCode: Int) -> [String: Any] {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let currentDate: String = df.string(from: Date())
        df.dateFormat = "HH:mm:ss"
        let currentTime: String = df.string(from: Date())
        
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
    
    func showAlert(title: String, message: String, vc: UIViewController) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil) )
        vc.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - get myexp data
    
    func myExpsData(selectedDate: Date, completion: @escaping  (Any)->()) {
        
        DatasManager.sharedInstance.myExpsData(selectedDate: selectedDate) { (any: Any) in
            DispatchQueue.main.async {
                let myexpsList: [MyExpsData] = any as! [MyExpsData]
                self.expenseList.removeAll()
                self.paymentList.removeAll()
                self.vendorList.removeAll()
                self.top10List.removeAll()
                
                for each in myexpsList {
                    if each.expense != nil {
                        self.expenseList = each.expense!
                    }
                    if each.payments != nil {
                        self.paymentList = each.payments!
                    }
                    if each.vendors != nil {
                        self.vendorList = each.vendors!
                    }
                    if each.top10 != nil {
                        self.top10List = each.top10!
                    }
                }
                let value: Any = self.expenseList as Any
                completion(value)
            }
        }
    }
    
    func myExpsWithDate(selectedDate: Date, completion: @escaping  (Any)->()) {
        
        DatasManager.sharedInstance.myExpsWithDate(selectedDate: selectedDate) { (any: Any) in
            DispatchQueue.main.async {
                let dataList: [Expense] = any as! [Expense]
                self.expenseList = dataList
                let value: Any = self.expenseList as Any
                completion(value)
            }
        }
    }
    
    //MARK: - save myexp data
    
    func saveMyexpsWithData(data: Expense, actionCode: Int, completion: @escaping  (Any)->()) {
        
        let parameters: [String: Any] = self.createParameters(data: data, actionCode: actionCode)
        DatasManager.sharedInstance.saveMyexpsWithParameters(parameters: parameters) { (any: Any) in
            DispatchQueue.main.async {
                let myexpsList: [EditMyExpsData] = any as! [EditMyExpsData]
                self.expenseList.removeAll()
                self.top10List.removeAll()
                
                for each in myexpsList {
                    if each.expense != nil {
                        self.expenseList = each.expense!
                    }
                    if each.top10 != nil {
                        self.top10List = each.top10!
                    }
                }
                let value: Any = self.expenseList as Any
                completion(value)
            }
        }
    }
    
    //MARK: - testing
    
    func saveHomeTest() {
        
        let data: HomeTest = HomeTest(name: "real test", value: "to save", notes: "calliing from the app")
        DatasManager.sharedInstance.saveHomeTest(data: data)
    }
    
}
