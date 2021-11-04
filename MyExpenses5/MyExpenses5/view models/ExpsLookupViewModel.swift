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
    
    func expsLookupData(year: String, month: String, completion: @escaping  (Any)->()) {
        
        DatasManager.sharedInstance.expenseLookup(year: year, month: month)  { (any: Any) in
            DispatchQueue.main.async {
                let dataList = any as? [Expense] ?? []
                self.expenseLookupList = dataList
                let value: Any = self.expenseLookupList as Any
                completion(value)
            }
        }
    }
    
}
