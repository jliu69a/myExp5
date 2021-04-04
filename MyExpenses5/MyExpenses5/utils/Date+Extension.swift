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
    
    func dateAndTimetoString() -> String {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: self)
    }
}
