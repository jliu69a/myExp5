//
//  ExpenseCell.swift
//  MyExps
//
//  Created by Johnson Liu on 1/14/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var cellVendorLabel: UILabel!
    @IBOutlet weak var cellNotesLabel: UILabel!
    @IBOutlet weak var cellAmountLabel: UILabel!
    @IBOutlet weak var cellPaymentLabel: UILabel!
    @IBOutlet weak var cellTimeLabel: UILabel!
    
    var isForLookup: Bool = false
    var dayOfWeek: String = ""
    
    func displayModelData(data: Expense) {

        self.cellVendorLabel.text = data.vendor ?? ""
        self.cellPaymentLabel.text = data.payment ?? ""
        self.cellNotesLabel.text = data.note ?? ""
        
        if self.isForLookup == true {
            let date = data.date ?? ""
            let weekday = self.dayOfWeek(date: date)
            self.cellTimeLabel.text = String(format: "( %@,  %@,  %@ )", date, weekday, (data.time ?? ""))
        }
        else {
            let displayTime = timeIn12HourFormat(time: (data.time ?? ""))
            self.cellTimeLabel.text = String(format: "( time: %@ )", displayTime)
        }
        
        let amountText: String = data.amount ?? "0"
        let amountValue: Double = (amountText as NSString).doubleValue
        self.cellAmountLabel.text = HelpingTools().displayInUSCurrency(value: amountValue)
        
        self.innerView.backgroundColor = UIColor.systemGray6
    }
    
    func dayOfWeek(date: String) -> String {
        if date.count == 0 {
            return ""
        }
        
        let weekday = Date().textToDate(format: "yyyy-MM-dd", dateText: date).dateToText(formate: "EEE")
        
        return weekday
    }
    
    func timeIn12HourFormat(time: String) -> String {
        
        if time.count == 0 {
            return ""
        }
        
        let timeIn12Hour = Date().textToDate(format: "HH:mm:ss", dateText: time).dateToText(formate: "hh:mm:ss a")
        return timeIn12Hour
    }
    
    func colorForData() -> UIColor {
        
        let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return .white
            case .dark: return .black
            @unknown default:
                return UIColor.clear
            }
        }
        
        return dynamicColor
    }
    
}
