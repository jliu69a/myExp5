//
//  UnitsConvertHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 1/5/26.
//  Copyright © 2026 Home Office. All rights reserved.
//

import UIKit

class UnitsConvertHomeViewController: UIViewController {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var unitsSegment: UISegmentedControl!
    
    @IBOutlet weak var originalValueLabel: UILabel!
    @IBOutlet weak var originalValueTextField: UITextField!
    
    @IBOutlet weak var convertedValueLabel: UILabel!
    @IBOutlet weak var convertedValueTextField: UITextField!
    
    @IBOutlet weak var convertToImperialButton: UIButton!
    @IBOutlet weak var convertToSIButton: UIButton!
    @IBOutlet weak var resetValuesButton: UIButton!
    
    var selectedUnitsCode: Int = UnitsConvertData.sharedInstance.kForTemperature
    var isFromSI: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Units Convert"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.unitsSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        self.unitsSegment.selectedSegmentIndex = 0
        self.selectedUnitsCode = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.innerView.layer.borderColor = UIColor.black.cgColor
        self.innerView.layer.borderWidth = 0.5
        
        self.convertToImperialButton.layer.cornerRadius = 20.0
        self.convertToImperialButton.clipsToBounds = true
        
        self.convertToSIButton.layer.cornerRadius = 20.0
        self.convertToSIButton.clipsToBounds = true
        
        self.resetValuesButton.layer.cornerRadius = 20.0
        self.resetValuesButton.clipsToBounds = true
        
        if #available(iOS 13.0, *) {
            self.unitsSegment.backgroundColor = UIColor.systemGray6
            self.unitsSegment.selectedSegmentTintColor = UIColor.systemBlue
            
            self.unitsSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            self.unitsSegment.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        }
        else {
            self.unitsSegment.tintColor = UIColor.systemBlue
        }
        
        self.displayReset()
        self.changeDisplay()
    }
    
    
    func clearKeyboard() {
        self.originalValueTextField.resignFirstResponder()
        self.convertedValueTextField.resignFirstResponder()
    }
    
    func displayReset() {
        self.originalValueTextField.text = ""
        self.convertedValueTextField.text = ""
    }
    
    func changeDisplay() {
        let convertManager = UnitsConvertManager()
        
        let originalValueTitle: String = convertManager.titleForOriginalValue(isFromSI: self.isFromSI, selectedUnitCode: self.selectedUnitsCode)
        let convertedValueTitle: String = convertManager.titleForConvertedValue(isFromSI: self.isFromSI, selectedUnitCode: self.selectedUnitsCode)
        
        self.originalValueLabel.text = String(format: "from %@:", originalValueTitle)
        self.convertedValueLabel.text = String(format: "to %@:", convertedValueTitle)
        
        self.convertedValueTextField.text = ""
    }
    
    func convertBetweenUnits() {
        let convertManager = UnitsConvertManager()
        let originalText: String = self.originalValueTextField.text ?? "0"
        
        let convertedOriginalValue: Double? = Double(originalText)
        if convertedOriginalValue == nil {
            self.originalValueTextField.text = String(format: "%0.0f", Double(0))
        }
        var originalValue: Double = convertedOriginalValue ?? 0
        
        if self.selectedUnitsCode == UnitsConvertData.sharedInstance.kForLength || self.selectedUnitsCode == UnitsConvertData.sharedInstance.kForVolume {
            
            if originalValue < Double(0) {
                originalValue = originalValue * Double(-1)
                self.originalValueTextField.text = String(format: "%f", originalValue)
            }
        }
        
        let convertedValue: Double = convertManager.convertValue(originalValue: originalValue, isFromSI: self.isFromSI, selectedUnitCode: self.selectedUnitsCode)
        let displayConvertedValue: String = String(format: "%f", convertedValue)
        self.convertedValueTextField.text = displayConvertedValue
    }
    
    
    @IBAction func convertToImperialAction(_ sender: Any) {
        self.clearKeyboard()
        self.isFromSI = true
        self.changeDisplay()
        self.convertBetweenUnits()
    }
    
    @IBAction func convertToSIAction(_ sender: Any) {
        self.clearKeyboard()
        self.isFromSI = false
        self.changeDisplay()
        self.convertBetweenUnits()
    }
    
    @IBAction func resetValuesAction(_ sender: Any) {
        self.clearKeyboard()
        self.displayReset()
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.clearKeyboard()
        
        if sender.selectedSegmentIndex == 0 {
            self.selectedUnitsCode = UnitsConvertData.sharedInstance.kForTemperature
        }
        else if sender.selectedSegmentIndex == 1 {
            self.selectedUnitsCode = UnitsConvertData.sharedInstance.kForLength
        }
        else if sender.selectedSegmentIndex == 2 {
            self.selectedUnitsCode = UnitsConvertData.sharedInstance.kForVolume
        }
        self.displayReset()
        self.changeDisplay()
    }
}


extension UnitsConvertHomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.clearKeyboard()
        return true
    }
}
