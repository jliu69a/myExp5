//
//  ExpenseCell.swift
//  MyExps
//
//  Created by Johnson Liu on 1/14/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
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
        
        let displayTime = HelpingTools().timeIn12HourFormat(time: (data.time ?? ""))
        
        if self.isForLookup == true {
            let helpingTool = HelpingTools()
            let date = data.date ?? ""
            let displayDate = helpingTool.displayCurrentDate(date: helpingTool.convertTextToDate(dateStr: date))
            self.cellTimeLabel.text = String(format: "( %@,  %@ )", displayDate, displayTime)
        }
        else {
            self.cellTimeLabel.text = String(format: "( time: %@ )", displayTime)
        }
        
        let amountText: String = data.amount ?? "0"
        let amountValue: Double = (amountText as NSString).doubleValue
        self.cellAmountLabel.text = HelpingTools().displayInUSCurrency(value: amountValue)
        
        self.innerView.backgroundColor = UIColor.systemGray6
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
