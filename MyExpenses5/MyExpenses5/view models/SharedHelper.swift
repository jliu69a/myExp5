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
        parametersLine = parametersLine.replacingOccurrences(of: " ", with: "+")

        return parametersLine
    }
}
