//
//  EditExpensesViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/18/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit
import Foundation


protocol EditExpensesViewControllerDelegate: AnyObject {
    func didChangeExpenseData(data: Expense, selectedDate: Date, isForNew: Bool, isDateChanged: Bool)
}


class EditExpensesViewController: UIViewController, UITextFieldDelegate, PaymentsVendorsViewControllerDelegate, ChangeDateViewControllerDelegate {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var priceTextLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var selectPaymentButton: UIButton!
    @IBOutlet weak var selectVendorButton: UIButton!
    @IBOutlet weak var changeDateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: EditExpensesViewControllerDelegate?
    
    var selectedExpense: Expense = Expense()
    
    var changeDateVC: ChangeDateViewController? = nil
    var selectedDate: Date = Date()
    var isDateChanged: Bool = false
    var amountData: String = ""
    var isForNew: Bool = false
    
    var topHeaderVC: TopHeaderViewController? = nil
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showTopView()
        
        self.priceTextField.text = self.selectedExpense.amount ?? ""
        self.priceTextLabel.text = self.selectedExpense.amount ?? "0.00"
        self.notesTextField.text = self.selectedExpense.note ?? ""

        self.displayPaymentData()
        self.displayVendorData()
        self.displayInitialDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topHeaderVC?.changeTitle(title: (self.isForNew ? "Add" : "Edit"))
        
        self.priceTextField.addTarget(self, action: #selector(changedPrice), for: UIControl.Event.editingChanged)
        
        self.selectPaymentButton.layer.cornerRadius = 5
        self.selectVendorButton.layer.cornerRadius = 5
        self.changeDateButton.layer.cornerRadius = 5
        self.saveButton.layer.cornerRadius = 5
    }
    
    //MARK: - top view
    
    func showTopView() {
        let frame = self.topView.frame
        if let vc = TopBarManager.sharedInstance.createTopHeader(frame: frame, title: "", isForAdmin: false) {
            vc.delegate = self
            self.topView.addSubview(vc.view)
            self.addChild(vc)
            self.topHeaderVC = vc
        }
    }
    
    //MARK: - helpers
    
    func displayPaymentData() {
        
        let title = self.isForNew ? "select a payment" : String(format: "%@ (%@)", (self.selectedExpense.payment ?? ""), (self.selectedExpense.payment_id ?? "0"))
        self.selectPaymentButton.setTitle(title, for: UIControl.State.normal)
        self.selectPaymentButton.setTitle(title, for: UIControl.State.highlighted)
    }
    
    func displayVendorData() {
        
        let title = self.isForNew ? "select a vendor" : String(format: "%@ (%@)", (self.selectedExpense.vendor ?? ""), (self.selectedExpense.vendor_id ?? "0"))
        self.selectVendorButton.setTitle(title, for: UIControl.State.normal)
        self.selectVendorButton.setTitle(title, for: UIControl.State.highlighted)
    }
    
    func displayInitialDate() {
        
        if self.isForNew {
            self.displayDate()
        }
        else {
            let dateStr = self.selectedExpense.date ?? Date().dateToText(formate: "yyyy-MM-dd")
            self.changeDateButton.setTitle(dateStr, for: UIControl.State.normal)
            self.changeDateButton.setTitle(dateStr, for: UIControl.State.highlighted)
        }
    }
    
    func displayDate() {
        
        self.selectedExpense.date = self.selectedDate.dateToText(formate: "yyyy-MM-dd")
        self.selectedExpense.time = self.selectedDate.dateToText(formate: "HH:mm:ss")
        
        self.changeDateButton.setTitle(self.selectedExpense.date, for: UIControl.State.normal)
        self.changeDateButton.setTitle(self.selectedExpense.date, for: UIControl.State.highlighted)
    }
    
    //MARK: - IB functiona
    
    @IBAction func gobackAction(_ sender: Any) {
        
        self.clearKeyboards()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPaymentAction(_ sender: Any) {
        self.clearKeyboards()
        
        if let vc = MEStoryboard.pv.vc as? PaymentsVendorsViewController {
            vc.isForAdmin = false
            vc.isForPayments = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func selectVendorAction(_ sender: Any) {
        self.clearKeyboards()
        
        if let vc = MEStoryboard.pv.vc as? PaymentsVendorsViewController {
            vc.isForAdmin = false
            vc.isForPayments = false
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func changeDateAction(_ sender: Any) {
        self.clearKeyboards()
        
        if let vc = MEStoryboard.home(MEHomePage.changeDate).vc as? ChangeDateViewController {
            vc.currentDate = self.selectedDate
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.changeDateVC = vc
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.clearKeyboards()
        
        if self.selectedExpense.payment_id == nil {
            MyExpDataManager.sharedInstance.showAlert(title: "Error", message: "Need to select a payment.", vc: self)
            return
        }
        if self.selectedExpense.vendor_id == nil {
            MyExpDataManager.sharedInstance.showAlert(title: "Error", message: "Need to select a vendor.", vc: self)
            return
        }
        
        self.selectedExpense.amount = self.priceTextLabel.text ?? "0"
        self.selectedExpense.note = self.notesTextField.text ?? ""
        
        //-- get the current time
        self.selectedExpense.time = Date().dateToText(formate: "HH:mm:ss")
        
        self.delegate?.didChangeExpenseData(data: self.selectedExpense, selectedDate: self.selectedDate, isForNew: self.isForNew, isDateChanged: self.isDateChanged)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - text field delegate
    
    func clearKeyboards() {
        self.priceTextField.resignFirstResponder()
        self.notesTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.clearKeyboards()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.priceTextField {
            
            //-- allow back space
            if string.count == 0 {
                return true
            }
            
            let priceValue: Int? = Int(string)
            if priceValue == nil {
                return false
            }
            else {
                return true
            }
        }
        
        return true
    }
    
    @objc func changedPrice() {
        
        let priceStr: String = self.priceTextField.text ?? "0.00"
        let priceValue: Float = fabsf((priceStr as NSString).floatValue / 100.0)
        self.amountData = String(format: "%0.2f", priceValue)
        self.priceTextLabel.text = self.amountData
    }
    
    //MARK: - class delegates
    
    func didSelectItem(isForPayment: Bool, name: String, id: String) {
        
        if isForPayment == true {
            self.selectedExpense.payment = name
            self.selectedExpense.payment_id = id
            self.displayPaymentData()
        }
        else {
            self.selectedExpense.vendor = name
            self.selectedExpense.vendor_id = id
            self.displayVendorData()
        }
    }
    
    func cancelSelectDate() {
        self.closeChangeDateView()
    }
    
    func selectNewDate(date: Date) {
        self.closeChangeDateView()
        
        self.selectedDate = date
        self.isDateChanged = true
        self.displayDate()
    }
    
    func closeChangeDateView() {
        
        if let vc = self.changeDateVC {
            vc.dismiss(animated: true, completion: nil)
        }
        self.changeDateVC = nil
    }

}

extension EditExpensesViewController: TopHeaderViewControllerDelegate {
    
    func goback() {
        self.clearKeyboards()
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAdmin() {
        //
    }
}
