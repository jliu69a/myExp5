//
//  AdminHomeViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/21/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class AdminHomeViewModel {
    
    var totalSections: Int = 1
    var totalRows: Int = 0
    
    let titlesList: [String] = ["Settings", "Reports"]
    let settingsList: [String] = ["Edit Payments", "Edit Vendors"]
    let reportsList: [String] = ["Look Up Vendor", "Look Up Expenses"]
}


extension AdminHomeViewModel {
    
    func numberOfSectionis() -> Int {
        return self.titlesList.count
    }
    
    func titleForSections(index: Int) -> String {
        return self.titlesList[index]
    }
    
    func numberOfRows(index: Int) -> Int {
        
        if index == 0 {
            return self.settingsList.count
        }
        else if index == 1 {
            return self.reportsList.count
        }
        else {
            return 0
        }
    }
    
    func rowAtIndex(section: Int, row: Int) -> String {
        
        if section == 0 {
            return self.settingsList[row]
        }
        else if section == 1 {
            return self.reportsList[row]
        }
        else {
            return ""
        }
    }
    
}
