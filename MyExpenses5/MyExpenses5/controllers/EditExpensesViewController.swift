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
    func didChangeExpenseData(data: Expense, selectedDate: Date, isForNew: Bool)
}


class EditExpensesViewController: UIViewController, UITextFieldDelegate, PaymentsVendorsViewControllerDelegate, ChangeDateViewControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceTextLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var selectPaymentButton: UIButton!
    @IBOutlet weak var selectVendorButton: UIButton!
    @IBOutlet weak var changeDateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: EditExpensesViewControllerDelegate?
    
    var selectedExpense: Expense? = nil
    
    var changeDateVC: ChangeDateViewController? = nil
    var selectedDate: Date = Date()
    var amountData: String = ""
    var isForNew: Bool = false
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.selectedExpense == nil {
            self.selectedExpense = Expense()
            self.isForNew = true
        }

        self.priceTextField.text = self.selectedExpense!.amount ?? ""
        self.priceTextLabel.text = self.selectedExpense!.amount ?? "0.00"
        self.notesTextField.text = self.selectedExpense!.note ?? ""

        self.displayPaymentData()
        self.displayVendorData()
        self.displayInitialDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleLabel.text = (self.isForNew == true) ? "Add" : "Edit"
        self.priceTextField.addTarget(self, action: #selector(changedPrice), for: UIControl.Event.editingChanged)
        
        self.selectPaymentButton.layer.cornerRadius = 5
        self.selectVendorButton.layer.cornerRadius = 5
        self.changeDateButton.layer.cornerRadius = 5
        self.saveButton.layer.cornerRadius = 5
    }
    
    //MARK: - helpers
    
    func displayPaymentData() {
        var title: String = "select a payment"
        
        if self.selectedExpense!.payment != nil && self.selectedExpense!.payment_id != nil {
            title = String(format: "%@ (%@)", self.selectedExpense!.payment!, self.selectedExpense!.payment_id!)
        }
        self.selectPaymentButton.setTitle(title, for: UIControl.State.normal)
        self.selectPaymentButton.setTitle(title, for: UIControl.State.highlighted)
    }
    
    func displayVendorData() {
        var title: String = "select a vendor"
        
        if self.selectedExpense!.vendor != nil && self.selectedExpense!.vendor_id != nil {
            title = String(format: "%@ (%@)", self.selectedExpense!.vendor!, self.selectedExpense!.vendor_id!)
        }
        self.selectVendorButton.setTitle(title, for: UIControl.State.normal)
        self.selectVendorButton.setTitle(title, for: UIControl.State.highlighted)
    }
    
    func displayInitialDate() {
        
        if self.selectedExpense!.date == nil || self.selectedExpense!.time == nil {
            self.selectedDate = Date()
            self.displayDate()
        }
        else {
            self.changeDateButton.setTitle(self.selectedExpense!.date!, for: UIControl.State.normal)
            self.changeDateButton.setTitle(self.selectedExpense!.date!, for: UIControl.State.highlighted)
        }
    }
    
    func displayDate() {
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateStr: String = df.string(from: self.selectedDate)
        self.selectedExpense!.date = dateStr
        
        self.changeDateButton.setTitle(dateStr, for: UIControl.State.normal)
        self.changeDateButton.setTitle(dateStr, for: UIControl.State.highlighted)
        
        df.dateFormat = "HH:mm:ss"
        let timeStr: String = df.string(from: self.selectedDate)
        self.selectedExpense!.time = timeStr
    }
    
    //MARK: - IB functiona
    
    @IBAction func gobackAction(_ sender: Any) {
        
        self.clearKeyboards()
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func selectPaymentAction(_ sender: Any) {
        self.clearKeyboards()
        
        let storyboard = UIStoryboard(name: "pandv", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PaymentsVendorsViewController") as? PaymentsVendorsViewController {
            vc.isForAdmin = false
            vc.isForPayments = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func selectVendorAction(_ sender: Any) {
        self.clearKeyboards()
        
        let storyboard = UIStoryboard(name: "pandv", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PaymentsVendorsViewController") as? PaymentsVendorsViewController {
            vc.isForAdmin = false
            vc.isForPayments = false
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func changeDateAction(_ sender: Any) {
        self.clearKeyboards()
        
        let storyboard: UIStoryboard = UIStoryboard.init(name: "expense", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ChangeDateViewController") as? ChangeDateViewController {
            self.changeDateVC = vc
            self.changeDateVC!.delegate = self
            self.changeDateVC!.currentDate = self.selectedDate
            self.present(self.changeDateVC!, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.clearKeyboards()
        
        if self.selectedExpense!.payment_id == nil {
            MyExpDataManager.sharedInstance.showAlert(title: "Error", message: "Need to select a payment.", vc: self)
            return
        }
        if self.selectedExpense!.vendor_id == nil {
            MyExpDataManager.sharedInstance.showAlert(title: "Error", message: "Need to select a vendor.", vc: self)
            return
        }
        
        self.selectedExpense!.amount = self.priceTextLabel.text!
        self.selectedExpense!.note = self.notesTextField.text ?? ""
        
        self.delegate?.didChangeExpenseData(data: self.selectedExpense!, selectedDate: self.selectedDate, isForNew: self.isForNew)
        self.navigationController!.popViewController(animated: true)
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
        
        var priceStr: String = "0.00"
        if self.priceTextLabel.text != nil && self.priceTextLabel.text!.count > 0 {
            priceStr = self.priceTextField.text!
        }
        let priceValue: Float = fabsf((priceStr as NSString).floatValue / 100.0)
        self.amountData = String(format: "%0.2f", priceValue)
        self.priceTextLabel.text = self.amountData
    }
    
    //MARK: - class delegates
    
    func didSelectItem(isForPayment: Bool, name: String, id: String) {
        
        if isForPayment == true {
            self.selectedExpense!.payment = name
            self.selectedExpense!.payment_id = id
            self.displayPaymentData()
        }
        else {
            self.selectedExpense!.vendor = name
            self.selectedExpense!.vendor_id = id
            self.displayVendorData()
        }
    }
    
    func cancelSelectDate() {
        self.closeChangeDateView()
    }
    
    func selectNewDate(date: Date) {
        self.closeChangeDateView()
        
        self.selectedDate = date
        self.displayDate()
    }
    
    func closeChangeDateView() {
        
        if self.changeDateVC != nil {
            self.changeDateVC!.dismiss(animated: true, completion: nil)
            self.changeDateVC = nil
        }
    }

}
