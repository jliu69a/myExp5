//
//  AdminPVAddEditViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/24/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class AdminPVAddEditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var idValue: String = "ID: 0"
    var nameValue: String = ""
    var isForPayment: Bool = false
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.idLabel.text = self.idValue
        self.nameTextField.text = self.nameValue
        
        if self.isForPayment == true {
            self.titleLabel.text = "Payment"
        }
        else {
            self.titleLabel.text = "Vendor"
        }
        self.saveButton.layer.cornerRadius = 5
    }
    
    //MARK: - IB actions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.clearKeyboard()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.clearKeyboard()
        
        //-- save action here.
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - text field delegate
    
    func clearKeyboard() {
        self.nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.clearKeyboard()
        return true
    }
    
    
}
