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
    
    let helper = SharedHelper()
    var totalDays: Int = 0
    var displayDate = ""
    
    var dailyStatusList = [String]()
    
    func retrieveDailyStatusData() {
        dailyStatusList = kUserDefault.array(forKey: appDele.kDailyCheckStatusKey) as? [String] ?? [String]()
        if dailyStatusList.count == 0 {
            dailyStatusList.append(contentsOf: helper.resetStatusList())
            saveDailyStatusData()
        }
        
        totalDays = helper.totalDaysOfMonth()
        displayDate = helper.dailyCheckDateText
    }
    
    func refreshDailyStatusData() {
        dailyStatusList.removeAll()
        dailyStatusList.append(contentsOf: helper.resetStatusList())
    }
    
    func saveDailyStatusData() {
        kUserDefault.set(dailyStatusList, forKey: appDele.kDailyCheckStatusKey)
        kUserDefault.synchronize()
    }
    
    func editDailyStatusData(index: Int, value: String) {
        if index >= dailyStatusList.count {
            return
        }
        dailyStatusList[index] = value
        saveDailyStatusData()
    }
}

extension DailyCheckViewModel {
    
    func numberOfSectionis() -> Int {
        return 1
    }
    
    func numberOfRows(index: Int) -> Int {
        return (totalDays > appDele.maxDaysInMonth) ? appDele.maxDaysInMonth : totalDays
    }
    
    func rowAtIndex(row: Int) -> String {
        return (row < dailyStatusList.count) ? dailyStatusList[row] : "0"
    }
}
