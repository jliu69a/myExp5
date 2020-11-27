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


class AdminPVAddEditViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: AdminPVAddEditViewControllerDelegate?
    
    var viewModel: PaymentVendorViewModel = PaymentVendorViewModel()
    var idValue: String = "0"
    var nameValue: String = ""
    var isForPayment: Bool = false
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
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
        self.viewModel.savePaymentsAndVendors(id: self.idValue, name: self.nameValue, isForPayment: self.isForPayment, isEdit: true)
    }
    
    func closePage() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: -

extension AdminPVAddEditViewController: UITextFieldDelegate {
    
    func clearKeyboard() {
        self.idTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.clearKeyboard()
        return true
    }
}


extension AdminPVAddEditViewController: PaymentVendorViewModelDelegate {
    
    func didLoadPaymentsAndVendors() {
        self.delegate?.didSaveChanges(isForPayment: self.isForPayment)
        self.closePage()
    }
}

