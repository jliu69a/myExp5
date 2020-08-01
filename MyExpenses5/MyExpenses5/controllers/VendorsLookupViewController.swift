//
//  VendorsLookupViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/31/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class VendorsLookupViewController: UIViewController, SelectMonthAndYearViewControllerDelegate {
    
    @IBOutlet weak var selectYearButton: UIButton!
    @IBOutlet weak var selectVendorButton: UIButton!
    @IBOutlet weak var lookupButton: UIButton!
    
    var selectedYear: String = "0"
    var selectedVendorId: String = "0"
    var selectedVendorName: String = "select a vendor"
    
    var selectVC: SelectMonthAndYearViewController? = nil
    
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
        //
    }
    
    @IBAction func chooseYearAction(_ sender: Any) {
        //
        
        let storyboard = UIStoryboard(name: "moneyAndYear", bundle: nil)
        self.selectVC = storyboard.instantiateViewController(withIdentifier: "SelectMonthAndYearViewController") as? SelectMonthAndYearViewController
        if self.selectVC != nil {
            self.selectVC!.delegate = self
            self.selectVC!.isForYearOnly = true
            self.present(self.selectVC!, animated: true, completion: nil)
        }
    }
    
    @IBAction func chooseVendorActiono(_ sender: Any) {
        //
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
}
