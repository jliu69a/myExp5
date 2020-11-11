//
//  PaymentVendorViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/11/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit


protocol PaymentVendorViewModelDelegate: class {
    func didLoadPaymentsAndVendors()
}


class PaymentVendorViewModel {
    
    weak var delegate: PaymentVendorViewModelDelegate?
    
    let appDele = UIApplication.shared.delegate as! AppDelegate
    //var totalSections: Int = 1
    //var totalRows: Int = 0
    
    var allPayments: [Payment] = []
    var allVendors: [Vendor] = []
    var vendorDisplayTitles: [String] = []
    var vendorDisplayData: [String: AnyObject] = [:]
    
    var isForPayments: Bool = true
    var isForAdmin: Bool = false
    
}

extension PaymentVendorViewModel {
    
    //MARK: - table view data
    
    func numberOfSectionis() -> Int {
        return self.isForPayments ? 1 : self.vendorDisplayTitles.count
    }
    
    func numberOfRows(section: Int) -> Int {
        if self.isForPayments {
            return self.allPayments.count
        }
        else {
            let key: String = self.vendorDisplayTitles[section]
            if section == 0 {
                let array = (self.vendorDisplayData[key] as? [Top10]) ?? []
                return array.count
            }
            else {
                let array = (self.vendorDisplayData[key] as? [Vendor]) ?? []
                return array.count
            }
        }
    }
    
    func rowAtIndex(indexPath: IndexPath) -> PAndVData {
        let data: PAndVData = PAndVData()
        
        if self.isForPayments {
            let item = self.allPayments[indexPath.row]
            data.name = item.payment ?? ""
            data.id = item.id ?? "0"
            data.displayId = item.id ?? "0"
        }
        else {
            let key: String = self.vendorDisplayTitles[indexPath.section]
            
            if indexPath.section == 0 {
                let array = (self.vendorDisplayData[key] as? [Top10]) ?? []
                let item = array[indexPath.row]
                data.name = item.vendor ?? ""
                
                let totalCount: String = item.total ?? "0"
                data.id = item.id ?? "0"
                data.displayId = String(format: "%@, total = %@", (item.id ?? "0"), totalCount)
            }
            else {
                let array = (self.vendorDisplayData[key] as? [Vendor]) ?? []
                let item = array[indexPath.row]
                data.name = item.vendor ?? ""
                data.id = item.id ?? "0"
                data.displayId = item.id ?? "0"
            }
        }
        return data
    }
    
    func headerHeightForSection(section: Int) -> CGFloat {
        
        if self.isForPayments == true {
            return 0
        }
        else {
            let key: String = self.appDele.vendorDisplayTitles[section]
            let array: [AnyObject] = (self.appDele.vendorDisplayData[key] as? [AnyObject]) ?? []
            return (array.count > 0) ? 40 : 0
        }
    }
    
    func headerTitleForSection(section: Int) -> String? {
        return self.isForPayments ? nil : self.appDele.vendorDisplayTitles[section]
    }
}

public class PAndVData: NSObject {
    
    var id: String = ""
    var name: String = ""
    var displayId: String = ""
    var isForPayments: Bool = false
}
