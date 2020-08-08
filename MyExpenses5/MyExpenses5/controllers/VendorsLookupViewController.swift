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
    
    var selectedYear: String = "0"
    var selectedVendorId: String = "0"
    var selectedVendorName: String = "select a vendor"
    
    var selectVC: SelectMonthAndYearViewController? = nil
    var selectVendor: PaymentsVendorsViewController? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        self.selectedYear = df.string(from: Date())
        
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
    
    //MARK: - IB functions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lookupAction(_ sender: Any) {
        
        print("> ")
        print("> look up vendor, year = \(self.selectedYear), vendor ID = \(self.selectedVendorId) ...")
        print("> ")
        
        MyExpDataManager.sharedInstance.vendorsLookupData(year: self.selectedYear, vendorId: self.selectedVendorId) { (any: Any) in
            DispatchQueue.main.async {
                let temp = any as! [Expense]
                print("-> ")
                print("-> at VC, vendor lookup, temp array size = \(temp.count) ")
                print("-> ")
            }
        }
    }
    
    @IBAction func chooseYearAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "moneyAndYear", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SelectMonthAndYearViewController") as? SelectMonthAndYearViewController {
            vc.delegate = self
            vc.isForYearOnly = true
            self.selectVC = vc
            self.present(self.selectVC!, animated: true, completion: nil)
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
    
    func didSelectYear(isForYearOnly: Bool, selectedYear: String, selectedMonthIndex: String) {
        
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
