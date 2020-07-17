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
    
    func myExpsData(selectedDate: Date, completion: @escaping  (Any)->()) {
        
        DatasManager.sharedInstance.myExpsData(selectedDate: Date()) { (any: Any) in
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
    
}
