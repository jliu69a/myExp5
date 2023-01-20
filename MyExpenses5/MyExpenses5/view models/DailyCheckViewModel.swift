//
//  DailyCheckViewModel.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 1/19/23.
//  Copyright © 2023 Home Office. All rights reserved.
//

import UIKit

class DailyCheckViewModel: NSObject {
    
    let appDele = UIApplication.shared.delegate as! AppDelegate
    let kUserDefault = UserDefaults.standard
    
    var dailyStatusList = [Bool]()
    
    func retrieveDailyStatusData() {
        dailyStatusList = kUserDefault.array(forKey: appDele.kDailyCheckStatusKey)! as? [Bool] ?? [Bool]()
        if dailyStatusList.count == 0 {
            dailyStatusList.append(contentsOf: SharedHelper().resetStatusList())
        }
    }
    
    func saveDailyStatusData() {
        kUserDefault.set(dailyStatusList, forKey: appDele.kDailyCheckStatusKey)
        kUserDefault.synchronize()
    }
    
    func editDailyStatusData(index: Int, value: Bool) {
        if index >= dailyStatusList.count {
            return
        }
        dailyStatusList[index] = value
    }
}

extension DailyCheckViewModel {
    
    func numberOfSectionis() -> Int {
        return 1
    }
    
    func numberOfRows(index: Int) -> Int {
        let totalDays = SharedHelper().totalDaysOfMonth()
        return (totalDays > appDele.maxDaysInMonth) ? appDele.maxDaysInMonth : totalDays
    }
    
    func rowAtIndex(row: Int) -> Bool {
        return (row < dailyStatusList.count) ? dailyStatusList[row] : false
    }
}
