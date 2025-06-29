//
//  HelpingTools.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 12/24/23.
//  Copyright © 2023 Home Office. All rights reserved.
//

import UIKit

class HelpingTools: NSObject {
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    func displayInUSCurrency(value: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        let valueString = currencyFormatter.string(from: NSNumber(value: value)) ?? "$0.00"
        // displays $9,999.99 in the US locale
        return valueString
    }
    
    //MARK: -
    
    func timeIn12HourFormat(time: String) -> String {
        
        if time.count == 0 {
            return ""
        }
        let timeIn12Hour = Date().textToDate(format: appDele.timeFormat, dateText: time).dateToText(formate: "hh:mm:ss a")
        return timeIn12Hour
    }
    
    func convertTextToDate(dateStr: String) -> Date {
        
        if dateStr.count == 0 {
            return Date()
        }
        return Date().textToDate(format: appDele.dateFormat, dateText: dateStr)
    }
    
    func displayCurrentDate(date: Date) -> String {
        return date.dateToText(formate: "MMM dd, yyyy  (EEE)")
    }
    
    func dayOfWeek(date: String) -> String {
        if date.count == 0 {
            return ""
        }
        return Date().textToDate(format: appDele.dateFormat, dateText: date).dateToText(formate: "EEE")
    }
    
    //MARK: -
    
    func showAlert(title: String?, message: String?, controller: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil) )
        controller.present(alert, animated: true, completion: nil)
    }
    
    //MARK: -
    
    func celsiusVsFahrenheit(value: Double, forCtoF: Bool) -> Double {
        var results: Double = 0
        
        if forCtoF {
            // Celsius to Fahrenheit : F = (C * 9/5) + 32
            results = (value * Double(9) / Double(5)) + Double(32)
        } else {
            // Fahrenheit to Celsius : C = (F - 32) * 5/9
            results = (value - Double(32)) * Double(5) / Double(9)
        }
        return results
    }
}
