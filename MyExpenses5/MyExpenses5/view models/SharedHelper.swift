//
//  SharedHelper.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/29/22.
//  Copyright © 2022 Home Office. All rights reserved.
//

import UIKit

class SharedHelper {
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: -
    
    func parseVendorsArray() {
        let vendorsList = self.appDele.vendorsList
        
        if vendorsList.count == 0 {
            return
        }
        
        let top10Key: String = "Top 10"
        self.appDele.vendorDisplayTitles.removeAll()
        self.appDele.vendorDisplayTitles.append(top10Key)
        
        self.appDele.vendorDisplayData.removeAll()
        self.appDele.vendorDisplayData[top10Key] = self.appDele.top10sList as AnyObject
        
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
    
    func escapeForHTMLCharacters(line: String) -> String {
        
        if line.count == 0 {
            return line
        }
        
        var parametersLine = line
        parametersLine = parametersLine.trimmingCharacters(in: .whitespacesAndNewlines)
        parametersLine = parametersLine.replacingOccurrences(of: "&", with: "*and*")
        parametersLine = parametersLine.replacingOccurrences(of: "+", with: "*plus*")
        parametersLine = parametersLine.replacingOccurrences(of: " ", with: "+")

        return parametersLine
    }
    
    //MARK: -
    
    func totalDaysOfMonth(date: Date? = nil) -> Int {
        
        var selecteDate = Date()
        if let theDate = date {
            selecteDate = theDate
        }
        
        let df = DateFormatter()
        
        df.dateFormat = "yyyy"
        let year: Int = Int(df.string(from: selecteDate)) ?? 0

        df.dateFormat = "MM"
        let month: Int = Int(df.string(from: selecteDate)) ?? 0

        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func resetStatusList() -> [Bool] {
        let appDele = UIApplication.shared.delegate as! AppDelegate
        
        var dataList = [Bool]()
        for _ in 0...appDele.maxDaysInMonth {
            dataList.append(false)
        }
        return dataList
    }
}
