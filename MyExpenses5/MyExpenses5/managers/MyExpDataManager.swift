//
//  MyExpDataManager.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/16/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class MyExpDataManager: NSObject {
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    static let sharedInstance = MyExpDataManager()
    
    let kInsertCode: Int = 1
    let kUpdateCode: Int = 2
    let kDeleteCode: Int = 3
    
    var totalSections: Int = 0
    var expenseList: [Expense] = []
    var paymentList: [Payment] = []
    var vendorList: [Vendor] = []
    var top10List: [Vendor] = []
    
    var vendorDisplayTitles: [String] = []
    var vendorDisplayData: [String: [Vendor]] = [:]
    
    let kPaymentsAndVendorsPageRefreshNotification: String = "Payments_And_Vendors_Page_Refresh_Notification"
    
    let monthsNameList: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    //MARK: - util functions
    
    func showDate(date: Date?) -> String {
        return (date ?? Date()).dateToText(formate: "\(appDele.dateFormat), E")
    }
    
    func createParameters(data: Expense, actionCode: Int) -> [String: Any] {
        
        let currentDate: String = Date().dateToText(formate: appDele.dateFormat)
        let currentTime: String = Date().dateToText(formate: appDele.timeFormat)
        
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
    
    func parseVendorsArray() {
        
        self.vendorDisplayTitles.removeAll()
        self.vendorDisplayData.removeAll()
        
        if self.vendorList.count == 0 {
            return
        }
        
        self.vendorDisplayData = Dictionary(grouping: self.vendorList, by: { self.firstCharForVendor(vendor: $0.vendor) })
        let allKeys = Array(self.vendorDisplayData.keys) as [String]
        self.vendorDisplayTitles = allKeys.sorted()
        
        let top10Key: String = "Top 10"
        self.vendorDisplayTitles.insert(top10Key, at: 0)
        self.vendorDisplayData[top10Key] = self.top10List
    }
    
    func firstCharForVendor(vendor: String?) -> String {
        
        let vendorName = vendor ?? ""
        guard let firstChar = vendorName.uppercased().first else {
            return ""
        }
        return String(firstChar)
    }
}
