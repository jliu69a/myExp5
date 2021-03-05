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
    
    var topHeaderVC: TopHeaderViewController? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.delegate = self
        self.showTopView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.idTextField.text = self.idValue
        self.nameTextField.text = self.nameValue
        
        if self.isForPayment == true {
            self.topHeaderVC?.changeTitle(title: "Payment")
        }
        else {
            self.topHeaderVC?.changeTitle(title: "Vendor")
        }
        self.saveButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.nameTextField.becomeFirstResponder()
    }
    
    //MARK: - top view
    
    func showTopView() {
        let storyboard = UIStoryboard(name: "topheader", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "TopHeaderViewController") as? TopHeaderViewController {
            let frame = self.topView.frame
            vc.view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            vc.delegate = self
            vc.headerTitle = ""
            vc.isForAdmin = false
            self.topView.addSubview(vc.view)
            self.addChild(vc)
            self.topHeaderVC = vc
        }
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
