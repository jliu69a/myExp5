//
//  Date+Extension.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 4/4/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit
import Foundation

extension Date {
    
    func dateToText(formate: String) -> String {
        let df = DateFormatter()
        df.dateFormat = formate
        let newText = df.string(from: self)
        return newText
    }
    
    func textToDate(format: String, dateText: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = format
        guard let newDate = df.date(from: dateText) else {
            return Date()
        }
        return newDate
    }
    
}
