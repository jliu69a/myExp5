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
    var types: CheckingTypes = .forProstate
    
    func retrieveDailyStatusData() {
        dailyStatusList = kUserDefault.array(forKey: retrieveCheckingKey(type: types)) as? [String] ?? [String]()
        if dailyStatusList.count == 0 {
            dailyStatusList.append(contentsOf: helper.resetStatusList())
            saveDailyStatusData()
        }
        
        totalDays = helper.totalDaysOfMonth()
        displayDate = String(format: "%@  (%@)", helper.dailyCheckDateText, displayCheckingKey(type: types))
    }
    
    private func retrieveCheckingKey(type: CheckingTypes) -> String {
        switch type {
        case .forProstate:
            return appDele.kDailyCheckStatusKey
        case .forVitamins:
            return appDele.kDailyVitaminsKey
        }
    }
    
    private func displayCheckingKey(type: CheckingTypes) -> String {
        switch type {
        case .forProstate:
            return "for Prostate"
        case .forVitamins:
            return "for Vitamins"
        }
    }
    
    func refreshDailyStatusData() {
        dailyStatusList.removeAll()
        dailyStatusList.append(contentsOf: helper.resetStatusList())
        saveDailyStatusData()
    }
    
    func saveDailyStatusData() {
        kUserDefault.set(dailyStatusList, forKey: retrieveCheckingKey(type: types))
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
    
    enum CheckingTypes {
        case forProstate, forVitamins
    }
    
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
