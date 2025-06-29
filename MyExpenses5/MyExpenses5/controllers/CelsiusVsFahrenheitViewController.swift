//
//  CelsiusVsFahrenheitViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 6/29/25.
//  Copyright © 2025 Home Office. All rights reserved.
//

import UIKit

class CelsiusVsFahrenheitViewController: UIViewController {
    
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var resultsTitleLabel: UILabel!
    @IBOutlet weak var resultsValueLabel: UILabel!
    @IBOutlet weak var CtoFButton: UIButton!
    @IBOutlet weak var FtoCButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Units Convert"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.CtoFButton.layer.cornerRadius = 22.5
        self.FtoCButton.layer.cornerRadius = 22.5
        self.clearButton.layer.cornerRadius = 22.5
    }
    
    //MARK: -
    
    @IBAction func convertCelsiusToFahrenheitAction(_ sender: Any) {
        self.dismissKeyboard()
        self.resultsTitleLabel.text = "Celsius to Fahrenheit :"
        self.toConvertTemperature(forCtoF: true)
    }
    
    @IBAction func convertFahrenheitToCelsiusAction(_ sender: Any) {
        self.dismissKeyboard()
        self.resultsTitleLabel.text = "Fahrenheit to Celsius :"
        self.toConvertTemperature(forCtoF: false)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        self.dismissKeyboard()
        self.temperatureTextField.text = ""
        self.resultsTitleLabel.text = "Results :"
        self.resultsValueLabel.text = "0"
    }
    
    //MARK: -
    
    func dismissKeyboard() {
        self.temperatureTextField.resignFirstResponder()
    }
    
    func toConvertTemperature(forCtoF: Bool) {
        
        var tempValue = self.temperatureTextField.text ?? ""
        if tempValue.isEmpty {
            tempValue = "0"
            self.temperatureTextField.text = "0"
        }
        
        let inputValue = Double(tempValue) ?? Double(0)
        self.temperatureTextField.text = String(format: "%0.2f", inputValue)
        
        let resultsValue = HelpingTools().celsiusVsFahrenheit(value: inputValue, forCtoF: forCtoF)
        let displayResultsValue = String(format: "%0.2f", resultsValue)
        
        self.resultsValueLabel.text = displayResultsValue
    }
    
}

extension CelsiusVsFahrenheitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
