//
//  PaymentVendorViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/11/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol PaymentVendorViewModelDelegate: class {
    func didLoadPaymentsAndVendors()
}


class PaymentVendorViewModel {
    
    weak var delegate: PaymentVendorViewModelDelegate?
    
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    let kInsertVendorCode: Int = 1
    let kUpdateVendorCode: Int = 2
    let kDeleteVendorCode: Int = 3
    
    var allPayments: [Payment] = []
    var allVendors: [Vendor] = []
    var vendorDisplayTitles: [String] = []
    var vendorDisplayData: [String: AnyObject] = [:]
    
    var isForPayments: Bool = true
    var isForAdmin: Bool = false
    
    var selectedVendor = EditedVendor()
    var vendorActionCode: Int = 0
}

//MARK: -

extension PaymentVendorViewModel {
    
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
                let array = (self.vendorDisplayData[key] as? [Vendor]) ?? []
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
                let array = (self.vendorDisplayData[key] as? [Vendor]) ?? []
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
    
    //MARK: - saving changes
    
    func savePaymentsAndVendors(id: String, name: String, isForPayment: Bool, isEdit: Bool) {
        
        self.isForPayments = isForPayment
        
        self.selectedVendor.id = id
        self.selectedVendor.name = name
        
        if id == "0" {
            self.vendorActionCode = kInsertVendorCode
        }
        else if isEdit {
            self.vendorActionCode = kUpdateVendorCode
        }
        else {
            self.vendorActionCode = kDeleteVendorCode
        }
        
        self.savePVData(id: id, name: name, isForPayment: isForPayment, isEdit: isEdit) {}
    }
    
    func savePVData(id: String, name: String, isForPayment: Bool, isEdit: Bool, completion: @escaping () -> Void) {
        
        let idValue: String = (id == "0") ? "-1" : id
        let isPaymentValue: String = isForPayment ? "1" : "0"
        let isEditValue: String = isEdit ? "1" : "0"
        
        let parameters: [String: Any] = ["id": (idValue as Any), "name": (name as Any), "ispayment": (isPaymentValue as Any), "edit":(isEditValue as Any)]
        
        let url: String = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/payments_vendors_edit.php", self.appDele.folder)
        let connect: ConnectionsManager = ConnectionsManager()
        
        connect.saveDataFromUrl(url: url, parameters: parameters) { [weak self] (data: Any) in
            if let rawData = data as? Data {
                let pvList: [ChangePVData] = self?.parseSavePaymentsAndVendors(data: rawData) ?? []
                self?.parseSavedPVData(myPVList: pvList)
                completion()
            }
        }
    }
    
    func parseSavePaymentsAndVendors(data: Data) -> [ChangePVData] {
        
        let json = try? JSON(data: data)
        if json == nil {
            return []
        }
        
        var dataList: [ChangePVData] = []
        do {
            dataList = try JSONDecoder().decode([ChangePVData].self, from: data)
        }
        catch {
            print(error)
        }
        return dataList
    }
    
    func parseSavedPVData(myPVList: [ChangePVData]) {
        
        self.appDele.paymentsList.removeAll()
        self.appDele.vendorsList.removeAll()
        
        for each in myPVList {
            if each.payments != nil {
                self.appDele.paymentsList = each.payments ?? []
            }
            if each.vendors != nil {
                self.appDele.vendorsList = each.vendors ?? []
            }
        }
        if !self.isForPayments {
            self.updateVendorsData()
        }
        self.delegate?.didLoadPaymentsAndVendors()
    }
    
    func updateVendorsData() {
        
        //-- update existing top-10 array
        let top10Key: String = "Top 10"
        var top10Vendors = (self.appDele.vendorDisplayData[top10Key] as? [Vendor]) ?? []
        
        var selectedIndex: Int = -1
        for index in 0..<top10Vendors.count {
            let item = top10Vendors[index]
            let idValue = item.id ?? "0"
            
            if self.selectedVendor.id == idValue {
                selectedIndex = index
                break
            }
        }
        
        if selectedIndex >= 0 {
            if self.vendorActionCode == kUpdateVendorCode {
                var selectedVendor = top10Vendors[selectedIndex]
                selectedVendor.vendor = self.selectedVendor.name
                top10Vendors[selectedIndex] = selectedVendor
            }
            else if self.vendorActionCode == kDeleteVendorCode {
                top10Vendors.remove(at: selectedIndex)
            }
        }
        
        //-- parse latest vendors
        let vendorsList = self.appDele.vendorsList
        if vendorsList.count == 0 {
            return
        }
        
        self.appDele.vendorDisplayTitles.removeAll()
        self.appDele.vendorDisplayTitles.append(top10Key)
        
        self.appDele.vendorDisplayData.removeAll()
        self.appDele.vendorDisplayData[top10Key] = top10Vendors as AnyObject
        
        let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        for each in vendorsList {
            let vendorName: String = (each.vendor ?? "").uppercased()
            
            var firstLetter: String = String(vendorName.prefix(1))
            if letters.contains(firstLetter) == false {
                firstLetter = "#"
            }
            
            if self.appDele.vendorDisplayTitles.contains(firstLetter) == false {
                self.appDele.vendorDisplayTitles.append(firstLetter)
            }
            var vendorsArray = (self.appDele.vendorDisplayData[firstLetter] as? [Vendor]) ?? []
            vendorsArray.append(each)
            self.appDele.vendorDisplayData[firstLetter] = vendorsArray as AnyObject
        }
    }
    
}

//MARK: -

public class PAndVData: NSObject {
    
    var id: String = ""
    var name: String = ""
    var displayId: String = ""
    var isForPayments: Bool = false
}

public class EditedVendor: NSObject {
    var id: String = ""
    var name: String = ""
}
