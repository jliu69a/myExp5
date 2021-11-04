//
//  VendorsLookupViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/31/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class VendorsLookupViewController: UIViewController, SelectMonthAndYearViewControllerDelegate, PaymentsVendorsViewControllerDelegate {
    
    @IBOutlet weak var selectYearButton: UIButton!
    @IBOutlet weak var selectVendorButton: UIButton!
    @IBOutlet weak var lookupButton: UIButton!
    
    let viewModel = VendorsLookupViewModel()
    
    var selectedYear: String = "0"
    var selectedVendorId: String = "0"
    var selectedVendorName: String = "select a vendor"
    
    var selectVC: SelectMonthAndYearViewController? = nil
    var selectVendor: PaymentsVendorsViewController? = nil
    
    var lookupTitlesList: [String] = []
    var lookupData: [String: LookupModel] = [:]
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Vendors Lookup"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        viewModel.clearVendorLookupData()
        
        self.selectedYear = Date().dateToText(formate: "yyyy")
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.normal)
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.highlighted)
        
        self.selectVendorButton.setTitle(self.selectedVendorName, for: UIControl.State.normal)
        self.selectVendorButton.setTitle(self.selectedVendorName, for: UIControl.State.highlighted)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectYearButton.layer.cornerRadius = 5
        self.selectVendorButton.layer.cornerRadius = 5
        self.lookupButton.layer.cornerRadius = 5
    }
    
    func showAlert(title: String?, message: String?) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil) )
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IB functions
    
    @IBAction func lookupAction(_ sender: Any) {
        
        if self.selectedVendorId == "0" {
            showAlert(title: "Need to select a vendor.", message: nil)
            return
        }
        
        let storyboard = UIStoryboard(name: "pandv", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "VendorsLookupDataViewController") as? VendorsLookupDataViewController {
            vc.selectedYear = self.selectedYear
            vc.selectedVendorId = self.selectedVendorId
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
    
    @IBAction func chooseVendorAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "pandv", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PaymentsVendorsViewController") as? PaymentsVendorsViewController {
            vc.isForAdmin = false
            vc.isForPayments = false
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
        
        if isForPayment == false {
            self.selectedVendorId = id
            self.selectedVendorName = name
            
            let displayVendor = String(format: "%@ (%@)", self.selectedVendorName, self.selectedVendorId)
            self.selectVendorButton.setTitle(displayVendor, for: UIControl.State.normal)
            self.selectVendorButton.setTitle(displayVendor, for: UIControl.State.highlighted)
        }
    }
}
