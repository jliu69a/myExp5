//
//  HelpingTools.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 12/24/23.
//  Copyright © 2023 Home Office. All rights reserved.
//

import UIKit

class HelpingTools: NSObject {
    
    func displayInUSCurrency(value: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        let valueString = currencyFormatter.string(from: NSNumber(value: value)) ?? "$0.00"
        // displays $9,999.99 in the US locale
        return valueString
    }
    
}
