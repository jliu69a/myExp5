//
//  PAndVLookupViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 9/10/23.
//  Copyright © 2023 Home Office. All rights reserved.
//

import UIKit

class PAndVLookupViewController: UIViewController, SelectMonthAndYearViewControllerDelegate, PaymentsVendorsViewControllerDelegate {
    
    @IBOutlet weak var selectYearButton: UIButton!
    @IBOutlet weak var selectPAndVButton: UIButton!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var lookupTitleLabel: UILabel!
    
    let viewModel = PAndVLookupViewModel()
    
    var isForPayment: Bool = false
    
    var selectedYear: String = "0"
    var selectedPAndVId: String = "0"
    var selectedPAndVName: String = ""
    var selectedItem: String = ""
    
    var selectVC: SelectMonthAndYearViewController? = nil
    var selectVendor: PaymentsVendorsViewController? = nil
    
    var lookupTitlesList: [String] = []
    var lookupData: [String: LookupModel] = [:]
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = isForPayment ? "Payments Lookup" : "Vendors Lookup"
        
        selectedPAndVName = isForPayment ? "select a payment" : "select a vendor"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        viewModel.clearPAndVLookupData()
        
        self.selectedYear = Date().dateToText(formate: "yyyy")
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.normal)
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.highlighted)
        
        self.selectPAndVButton.setTitle(self.selectedPAndVName, for: UIControl.State.normal)
        self.selectPAndVButton.setTitle(self.selectedPAndVName, for: UIControl.State.highlighted)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectYearButton.layer.cornerRadius = 5
        self.selectPAndVButton.layer.cornerRadius = 5
        self.lookupButton.layer.cornerRadius = 5
        
        self.lookupTitleLabel.text = isForPayment ? "Payment" : "Vendor"
    }
    
    func showAlert(title: String?, message: String?) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil) )
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IB functions
    
    @IBAction func lookupAction(_ sender: Any) {
        
        if self.selectedPAndVId == "0" {
            let title = self.isForPayment ? "Need to select a payment." : "Need to select a vendor."
            showAlert(title: title, message: nil)
            return
        }
        
        let storyboard = UIStoryboard(name: "pandv", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "PAndVLookupDataViewController") as? PAndVLookupDataViewController {
            vc.selectedYear = self.selectedYear
            vc.selectedPAndVId = self.selectedPAndVId
            vc.selectedItem = self.selectedItem
            vc.isForPayment = self.isForPayment
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func chooseYearAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "monthAndYear", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SelectMonthAndYearViewController") as? SelectMonthAndYearViewController {
            vc.delegate = self
            vc.isForYearOnly = true
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            self.selectVC = vc
        }
    }
    
    @IBAction func choosePAndVAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "pandv", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PaymentsVendorsViewController") as? PaymentsVendorsViewController {
            vc.isForAdmin = false
            vc.isForPayments = self.isForPayment
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - delegates
    
    func cancelYearSelection() {
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
    
    func didSelectYear(isForYearOnly: Bool, selectedYear: String, selectedMonthIndex: String, selectedMonthText: String) {
        
        self.selectedYear = selectedYear
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.normal)
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.highlighted)
        
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
    
    func didSelectItem(isForPayment: Bool, name: String, id: String) {
        
        self.selectedPAndVId = id
        self.selectedPAndVName = name
        self.selectedItem = self.isForPayment ? "Payment: \(name)" : "Vendor: \(name)"
        
        let displayPAndV = String(format: "%@ (%@)", self.selectedPAndVName, self.selectedPAndVId)
        self.selectPAndVButton.setTitle(displayPAndV, for: UIControl.State.normal)
        self.selectPAndVButton.setTitle(displayPAndV, for: UIControl.State.highlighted)
    }
}
