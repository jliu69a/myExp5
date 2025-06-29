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
    
    let titlesList = ["Settings", "Reports", "Misc"]
    let settingsList = ["Edit Payments", "Edit Vendors"]
    let reportsList = ["Vendor Look Up", "Payment Look Up", "Expenses Look Up"]
    let miscList = ["Units Conversion", "Current Location"]
}


extension AdminHomeViewModel {
    
    func numberOfSectionis() -> Int {
        return self.titlesList.count
    }
    
    func titleForSections(index: Int) -> String {
        return self.titlesList[index]
    }
    
    func numberOfRows(index: Int) -> Int {
        var totalRows: Int = 0
        
        switch index {
        case 0:
            totalRows = self.settingsList.count
            break
        case 1:
            totalRows = self.reportsList.count
            break
        case 2:
            totalRows = self.miscList.count
            break
        default:
            break
        }
        
        return totalRows
    }
    
    func rowAtIndex(section: Int, row: Int) -> String {
        
        if section == 0 {
            return self.settingsList[row]
        }
        else if section == 1 {
            return self.reportsList[row]
        }
        else if section == 2 {
            return self.miscList[row]
        }
        else {
            return ""
        }
    }
    
}
