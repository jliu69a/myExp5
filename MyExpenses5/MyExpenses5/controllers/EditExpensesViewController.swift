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


class EditExpensesViewController: UIViewController {
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var priceTextLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var selectPaymentButton: UIButton!
    @IBOutlet weak var selectVendorButton: UIButton!
    @IBOutlet weak var changeDateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var titleView: UIView!
    
    weak var delegate: EditExpensesViewControllerDelegate?
    
    var pageTitle: String = ""
    var selectedExpense: Expense = Expense()
    
    var selectedDate: Date = Date()
    var isDateChanged: Bool = false
    var amountData: String = ""
    var isForNew: Bool = false
    
    var topHeaderVC: TopHeaderViewController? = nil
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = pageTitle
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.priceTextField.text = self.selectedExpense.amount ?? ""
        self.priceTextLabel.text = self.selectedExpense.amount ?? "0.00"
        self.notesTextField.text = self.selectedExpense.note ?? ""

        self.displayPaymentData(isFirstTime: true)
        self.displayVendorData(isFirstTime: true)
        self.displayInitialDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //-- not to use
        //self.showTitleView()
        
        self.topHeaderVC?.changeTitle(title: (self.isForNew ? "Add" : "Edit"))
        
        self.priceTextField.addTarget(self, action: #selector(changedPrice), for: UIControl.Event.editingChanged)
        
        self.selectPaymentButton.layer.cornerRadius = 5
        self.selectVendorButton.layer.cornerRadius = 5
        self.changeDateButton.layer.cornerRadius = 5
        self.saveButton.layer.cornerRadius = 5
    }
    
    //MARK: - title view
    
    func showTitleView() {
        
        //-- not to use
        let storyboard = UIStoryboard(name: "sharedHeader", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "SharedHeaderViewController") as? SharedHeaderViewController {
            
            let frame = self.titleView.frame
            vc.view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            self.titleView.addSubview(vc.view)
            
            vc.backButton.addTarget(self, action: #selector(toClosePage), for: .touchUpInside)
            
            self.addChild(vc)
            vc.showData(title: (self.isForNew ? "Add" : "Edit"))
        }
    }
    
    @objc func toClosePage() {
        //-- not to use
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - helpers
    
    @objc func changedPrice() {
        
        let priceStr: String = self.priceTextField.text ?? "0.00"
        let priceValue: Float = fabsf((priceStr as NSString).floatValue / 100.0)
        self.amountData = String(format: "%0.2f", priceValue)
        self.priceTextLabel.text = self.amountData
    }
    
    func displayPaymentData(isFirstTime: Bool) {
        var title = ""
        
        if isFirstTime {
            title = self.isForNew ? "Select a Payment" : String(format: "%@ (%@)", (self.selectedExpense.payment ?? ""), (self.selectedExpense.payment_id ?? "0"))
        }
        else {
            title = String(format: "%@ (%@)", (self.selectedExpense.payment ?? ""), (self.selectedExpense.payment_id ?? "0"))
        }
        self.selectPaymentButton.setTitle(title, for: UIControl.State.normal)
        self.selectPaymentButton.setTitle(title, for: UIControl.State.highlighted)
    }
    
    func displayVendorData(isFirstTime: Bool) {
        var title = ""
        
        if isFirstTime {
            title = self.isForNew ? "Select a Vendor" : String(format: "%@ (%@)", (self.selectedExpense.vendor ?? ""), (self.selectedExpense.vendor_id ?? "0"))
        }
        else {
            title = String(format: "%@ (%@)", (self.selectedExpense.vendor ?? ""), (self.selectedExpense.vendor_id ?? "0"))
        }
        self.selectVendorButton.setTitle(title, for: UIControl.State.normal)
        self.selectVendorButton.setTitle(title, for: UIControl.State.highlighted)
    }
    
    func displayInitialDate() {
        
        if self.isForNew {
            self.displayDate()
        }
        else {
            let dateStr = self.selectedExpense.date ?? Date().dateToText(formate: appDele.dateFormat)
            let displayDate = displayDate(dateStr: dateStr)
            self.changeDateButton.setTitle(displayDate, for: UIControl.State.normal)
            self.changeDateButton.setTitle(displayDate, for: UIControl.State.highlighted)
        }
    }
    
    func displayDate() {
        
        self.selectedExpense.date = self.selectedDate.dateToText(formate: appDele.dateFormat)
        self.selectedExpense.time = self.selectedDate.dateToText(formate: appDele.timeFormat)
        let displayDate = displayDate(dateStr: self.selectedExpense.date ?? "")
        
        self.changeDateButton.setTitle(displayDate, for: UIControl.State.normal)
        self.changeDateButton.setTitle(displayDate, for: UIControl.State.highlighted)
    }
    
    private func displayDate(dateStr: String) -> String {
        if dateStr.count == 0 {
            return ""
        }
        return HelpingTools().displayCurrentDate(date: HelpingTools().convertTextToDate(dateStr: dateStr))
    }
    
    //MARK: - IB functiona
    
    @IBAction func gobackAction(_ sender: Any) {
        
        self.clearKeyboards()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPaymentAction(_ sender: Any) {
        self.clearKeyboards()
        
        if let vc = MEStoryboard.pv.vc as? PaymentsVendorsViewController {
            vc.pageTitle = "Payment"
            vc.isForAdmin = false
            vc.isForPayments = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func selectVendorAction(_ sender: Any) {
        self.clearKeyboards()
        
        if let vc = MEStoryboard.pv.vc as? PaymentsVendorsViewController {
            vc.pageTitle = "Vendor"
            vc.isForAdmin = false
            vc.isForPayments = false
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func changeDateAction(_ sender: Any) {
        self.clearKeyboards()
        
        let storyboard = UIStoryboard(name: "chooseDate", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ChooseDateViewController") as? ChooseDateViewController {
            vc.delegate = self
            vc.selectedDate = self.selectedDate
            self.navigationController?.pushViewController(vc, animated: true)
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
        self.selectedExpense.time = Date().dateToText(formate: appDele.timeFormat)
        
        self.delegate?.didChangeExpenseData(data: self.selectedExpense, selectedDate: self.selectedDate, isForNew: self.isForNew, isDateChanged: self.isDateChanged)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: -

extension EditExpensesViewController: UITextFieldDelegate {
    
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
}

//MARK: -

extension EditExpensesViewController: PaymentsVendorsViewControllerDelegate {
    
    func didSelectItem(isForPayment: Bool, name: String, id: String) {
        
        if isForPayment == true {
            self.selectedExpense.payment = name
            self.selectedExpense.payment_id = id
            self.displayPaymentData(isFirstTime: false)
        }
        else {
            self.selectedExpense.vendor = name
            self.selectedExpense.vendor_id = id
            self.displayVendorData(isFirstTime: false)
        }
    }
}

//MARK: -

extension EditExpensesViewController: ChooseDateViewControllerDelegate {
    
    func selectNewDate(date: Date) {
        self.selectedDate = date
        self.isDateChanged = true
        self.displayDate()
    }
}
