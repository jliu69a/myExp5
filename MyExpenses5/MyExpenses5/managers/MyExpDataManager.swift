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
    
}
