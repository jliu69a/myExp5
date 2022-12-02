//
//  VendorsLookupViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/4/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit

class VendorsLookupViewModel: NSObject {
    
    var lookupTitlesList: [String] = []
    var lookupData: [String: LookupModel] = [:]
    
    //MARK: -
    
    func vendorsLookupData(year: String, vendorId: String, completion: @escaping  (Any)->()) {
        
        DatasManager.sharedInstance.vendorsLookup(year: year, vendorId: vendorId) { (any: Any) in
            DispatchQueue.main.async {
                let dataList = any as? [MyExpsData] ?? []
                
                if dataList.count > 0 {
                    let each = dataList[0]
                    let expsListWithVendor: [Expense] = each.expense ?? []
                    self.parseVendorLookupsData(list: expsListWithVendor)
                }
                
                let temp: [Expense] = []
                completion(temp)
            }
        }
    }
    
    func clearVendorLookupData() {
        self.lookupTitlesList.removeAll()
        self.lookupData.removeAll()
    }
    
    func parseVendorLookupsData(list: [Expense]) {
        
        self.clearVendorLookupData()
        if list.count == 0 {
            return
        }
        
        for each in list {
            let dateText = each.date ?? ""
            let dateTitle = self.createLookupTitle(dateText: dateText)
            
            if self.lookupTitlesList.contains(dateTitle) == false {
                self.lookupTitlesList.append(dateTitle)
            }
            
            let model = self.lookupData[dateTitle] ?? LookupModel()
            model.date = dateTitle
            
            let amount = each.amount ?? "0"
            let amountValue = Float(amount) ?? 0
            model.total += amountValue
            
            model.exps.append(each)
            self.lookupData[dateTitle] = model
        }
    }
    
    func createLookupTitle(dateText: String) -> String {
        if dateText.count == 0 {
            return ""
        }
        return Date().textToDate(format: "yyyy-MM-dd", dateText: dateText).dateToText(formate: "MMMM")
    }
}

extension VendorsLookupViewModel {
    
    func lookupSections() -> Int {
        return lookupTitlesList.count
    }
    
    func lookupItemForSection(section: Int) -> Int {
        let title = self.lookupTitlesList[section]
        let model = self.lookupData[title] ?? LookupModel()
        return model.exps.count
    }
    
    func lookupData(indexPath: IndexPath) -> Expense {
        let title = self.lookupTitlesList[indexPath.section]
        let model = self.lookupData[title] ?? LookupModel()
        return model.exps[indexPath.row]
    }
    
    func lookupTitleForSection(section: Int) -> String {
        let title = lookupTitlesList[section]
        let model = lookupData[title] ?? LookupModel()
        return String(format: "%@, total ($) = %0.2f", model.date, model.total)
    }
    
}
