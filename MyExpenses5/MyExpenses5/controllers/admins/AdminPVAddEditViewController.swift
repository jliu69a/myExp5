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
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: AdminPVAddEditViewControllerDelegate?
    
    var viewModel: PaymentVendorViewModel = PaymentVendorViewModel()
    var idValue: String = "0"
    var nameValue: String = ""
    var isForPayment: Bool = false
    var pageTitle: String = ""
    
    var topHeaderVC: TopHeaderViewController? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        pageTitle = self.isForPayment ? "Payment" : "Vendor"
        
        self.title = pageTitle
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.idTextField.text = self.idValue
        self.nameTextField.text = self.nameValue
        
        self.topHeaderVC?.changeTitle(title: pageTitle)
        self.saveButton.layer.cornerRadius = 5
        
        setupTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.nameTextField.becomeFirstResponder()
    }
    
    //MARK: - tool bar for text field
    
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        idTextField.inputAccessoryView = toolbar
        nameTextField.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() {
        view.endEditing(true)
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

extension AdminPVAddEditViewController: TopHeaderViewControllerDelegate {
    
    func goback() {
        self.clearKeyboard()
        self.closePage()
    }
    
    func showAdmin() {
        //
    }
}
