//
//  UnitsConvertManager.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 1/5/26.
//  Copyright © 2026 Home Office. All rights reserved.
//

import UIKit

class UnitsConvertManager: NSObject {
    
    func titleForOriginalValue(isFromSI: Bool, selectedUnitCode: Int) -> String {
        switch selectedUnitCode {
        case UnitsConvertData.sharedInstance.kForTemperature:
            return isFromSI ? "Cellerius" : "Faherenheit"
        case UnitsConvertData.sharedInstance.kForLength:
            return isFromSI ? "Meters" : "Feet"
        case UnitsConvertData.sharedInstance.kForVolume:
            return isFromSI ? "Litters" : "Garlons"
        default:
            break
        }
        return ""
    }
    
    func titleForConvertedValue(isFromSI: Bool, selectedUnitCode: Int) -> String {
        switch selectedUnitCode {
        case UnitsConvertData.sharedInstance.kForTemperature:
            return isFromSI ? "Faherenheit" : "Cellerius"
        case UnitsConvertData.sharedInstance.kForLength:
            return isFromSI ? "Feet" : "Meters"
        case UnitsConvertData.sharedInstance.kForVolume:
            return isFromSI ? "Garlons" : "Litters"
        default:
            break
        }
        return ""
    }
    
    
    func convertValue(originalValue: Double, isFromSI: Bool, selectedUnitCode: Int) -> Double {
        
        var newOriginalValue: Double = originalValue
        var resultsValue: Double = 0.0
        
        if selectedUnitCode == UnitsConvertData.sharedInstance.kForLength || selectedUnitCode == UnitsConvertData.sharedInstance.kForVolume {
            if newOriginalValue < Double(0) {
                newOriginalValue = newOriginalValue * Double(-1)
            }
        }
        
        switch selectedUnitCode {
        case UnitsConvertData.sharedInstance.kForTemperature:
            resultsValue = isFromSI ? (newOriginalValue * Double(1.8)) + Double(32) : (newOriginalValue - Double(32)) / Double(1.8)
            break
        case UnitsConvertData.sharedInstance.kForLength:
            resultsValue = isFromSI ? newOriginalValue * Double(3.281) : newOriginalValue / Double(3.281)
            break
        case UnitsConvertData.sharedInstance.kForVolume:
            resultsValue = isFromSI ? newOriginalValue * Double(3.785) : newOriginalValue / Double(3.785)
            break
        default:
            break
        }
        
        return resultsValue
    }
}
