//
//  ExpsLookupViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/4/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit

class ExpsLookupViewModel: NSObject {
    
    var expenseLookupList: [Expense] = []
    
    var lookupDaysList: [String] = []
    var lookupData: [String: [Expense]] = [:]
    
    var amountTotal: Double = 0
    
    func expsLookupData(year: String, month: String, completion: @escaping  (Any)->()) {
        
        DatasManager.sharedInstance.expenseLookup(year: year, month: month)  { (any: Any) in
            DispatchQueue.main.async {
                let dataList = any as? [Expense] ?? []
                self.expenseLookupList = dataList
                self.parseExpsLookupData()
                let value: Any = self.expenseLookupList as Any
                completion(value)
            }
        }
    }
    
    func parseExpsLookupData() {
        
        self.lookupDaysList.removeAll()
        self.lookupData.removeAll()
        
        let defaultDate = Date().dateToText(formate: "yyyy-MM-dd")
        
        for eachExp in self.expenseLookupList {
            let dayText = (eachExp.date ?? defaultDate).suffix(2)
            let displayDay = "\(Int(dayText) ?? 0)"
            
            if let value = eachExp.amount {
                amountTotal += Double(value) ?? 0
            }
            
            if !self.lookupDaysList.contains(displayDay) {
                self.lookupDaysList.append(displayDay)
            }
            
            var list = self.lookupData[displayDay] ?? []
            list.append(eachExp)
            self.lookupData[displayDay] = list
        }
    }
    
}
