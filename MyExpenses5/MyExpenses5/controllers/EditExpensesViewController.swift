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
    
    func startShowingActivityIndicator()
}


class EditExpensesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceTextLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var selectPaymentButton: UIButton!
    @IBOutlet weak var selectVendorButton: UIButton!
    @IBOutlet weak var changeDateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedExpense: Expense? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleLabel.text = (self.selectedExpense == nil) ? "Add" : "Edit"
        
        self.selectPaymentButton.setTitle("select a payment", for: UIControl.State.normal)
        self.selectPaymentButton.setTitle("select a payment", for: UIControl.State.highlighted)
        
        self.selectVendorButton.setTitle("select a vendor", for: UIControl.State.normal)
        self.selectVendorButton.setTitle("select a vendor", for: UIControl.State.highlighted)
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        var today: String = df.string(from: Date())
        
        if self.selectedExpense == nil {
            self.priceTextField.text = nil
            self.priceTextLabel.text = "0.00"
            self.notesTextField.text = nil
        }
        else {
            self.priceTextField.text = self.selectedExpense!.amount!
            self.priceTextLabel.text = self.selectedExpense!.amount!
            self.notesTextField.text = self.selectedExpense!.note!
            
            today = self.selectedExpense!.date ?? today
        }
        
        self.changeDateButton.setTitle(today, for: UIControl.State.normal)
        self.changeDateButton.setTitle(today, for: UIControl.State.highlighted)
        
        if self.selectedExpense != nil {
            let payment: String = String(format: "%@ (%@)", self.selectedExpense!.payment!, self.selectedExpense!.payment_id!)
            self.selectPaymentButton.setTitle(payment, for: UIControl.State.normal)
            self.selectPaymentButton.setTitle(payment, for: UIControl.State.highlighted)
            
            let vendor: String = String(format: "%@ (%@)", self.selectedExpense!.vendor!, self.selectedExpense!.vendor_id!)
            self.selectVendorButton.setTitle(vendor, for: UIControl.State.normal)
            self.selectVendorButton.setTitle(vendor, for: UIControl.State.highlighted)
        }
    }
    
    //MARK: - IB functiona
    
    @IBAction func gobackAction(_ sender: Any) {
        
        self.clearKeyboards()
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func selectPaymentAction(_ sender: Any) {
        //
    }
    
    @IBAction func selectVendorAction(_ sender: Any) {
        //
    }
    
    @IBAction func changeDateAction(_ sender: Any) {
        //
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if self.selectedExpense == nil {
            return
        }
        
        self.clearKeyboards()
        
        //-- add or edit here.
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
}
