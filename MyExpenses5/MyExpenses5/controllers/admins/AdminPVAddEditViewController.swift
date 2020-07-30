//
//  AdminPVAddEditViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/24/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit


protocol AdminPVAddEditViewControllerDelegate: AnyObject {
    func didSaveChanges(isForPayment: Bool)
}


class AdminPVAddEditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: AdminPVAddEditViewControllerDelegate?
    
    var idValue: String = "0"
    var nameValue: String = ""
    var isForPayment: Bool = false
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.idTextField.text = self.idValue
        self.nameTextField.text = self.nameValue
        
        if self.isForPayment == true {
            self.titleLabel.text = "Payment"
        }
        else {
            self.titleLabel.text = "Vendor"
        }
        self.saveButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.nameTextField.becomeFirstResponder()
    }
    
    //MARK: - IB actions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.clearKeyboard()
        self.closePage()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.clearKeyboard()
        
        //-- save action here.
        self.nameValue = self.nameTextField.text ?? ""
        
        MyExpDataManager.sharedInstance.savePaymentsAndVendors(id: self.idValue, name: self.nameValue, isForPayment: self.isForPayment, isEdit: true) { (any: Any) in
            DispatchQueue.main.async {
                let list: [String: AnyObject] = any as! [String: AnyObject]
                print("-> edit a payment/vendor, result array size = \(list.count) ")
                self.refreshPage()
            }
        }
    }
    
    func refreshPage() {
        self.delegate?.didSaveChanges(isForPayment: self.isForPayment)
        self.closePage()
    }
    
    func closePage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - text field delegate
    
    func clearKeyboard() {
        self.idTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.clearKeyboard()
        return true
    }
}
