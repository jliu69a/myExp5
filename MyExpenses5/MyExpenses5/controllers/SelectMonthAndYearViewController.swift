//
//  SelectMonthAndYearViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/31/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit


protocol SelectMonthAndYearViewControllerDelegate: AnyObject {
    
    func cancelYearSelection()
    func didSelectYear(isForYearOnly: Bool, selectedYear: String, selectedMonthIndex: String)
}


class SelectMonthAndYearViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: SelectMonthAndYearViewControllerDelegate?
    
    var isForYearOnly: Bool = false
    
    var currentYearIndex: Int = 0
    var currentMonthIndex: Int = 0
    
    var monthsList: [String] = []
    var yearsList: [String] = []
    
    var selectedYear: String = "0"
    var selectedMonthIndex: String = "0"
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cancelButton.layer.cornerRadius = 5
        self.saveButton.layer.cornerRadius = 5
        
        self.titleLabel.text = (self.isForYearOnly == true) ? "Choose A Year" : "Choose A Month and A Year"
        self.monthsList = MyExpDataManager.sharedInstance.monthsNameList
        
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        let yearText = df.string(from: Date())
        let yearValue = Int(yearText) ?? 0
        
        df.dateFormat = "MM"
        self.currentMonthIndex = (Int(df.string(from: Date())) ?? 0) - 1
        
        let beginYearValue = yearValue - 20
        let endYearValue = yearValue + 20
        self.yearsList.removeAll()
        
        for index in beginYearValue...endYearValue {
            self.yearsList.append(String(index))
        }
        self.currentYearIndex = self.yearsList.firstIndex(of: yearText) ?? 0

        self.picker.reloadAllComponents()
        
        if self.isForYearOnly == true {
            self.picker.selectRow(self.currentYearIndex, inComponent: 0, animated: true)
            self.selectedYear = yearText
        }
        else  {
            self.picker.selectRow(self.currentMonthIndex, inComponent: 0, animated: true)
            self.picker.selectRow(self.currentYearIndex, inComponent: 1, animated: true)
            
            self.selectedYear = yearText
            self.selectedMonthIndex = "\(self.currentMonthIndex)"
        }
    }
    
    //MARK: - IB functions
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.cancelYearSelection()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.delegate?.didSelectYear(isForYearOnly: self.isForYearOnly, selectedYear: self.selectedYear, selectedMonthIndex: self.selectedMonthIndex)
    }
    
    //MARK: - picker view source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return (self.isForYearOnly == true) ? 1 : 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.isForYearOnly == true || component == 1 {
            return self.yearsList.count
        }
        else {
            return self.monthsList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if self.isForYearOnly == true || component == 1 {
            return self.yearsList[row]
        }
        else {
            return self.monthsList[row]
        }
    }
    
    //MARK: - picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.isForYearOnly == true || component == 1 {
            self.selectedYear = self.yearsList[row]
        }
        else {
            self.selectedMonthIndex = self.monthsList[row]
        }
    }
    
}
