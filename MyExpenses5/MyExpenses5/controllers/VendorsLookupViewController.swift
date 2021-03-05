//
//  VendorsLookupViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/31/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class VendorsLookupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectMonthAndYearViewControllerDelegate, PaymentsVendorsViewControllerDelegate {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var selectYearButton: UIButton!
    @IBOutlet weak var selectVendorButton: UIButton!
    @IBOutlet weak var lookupButton: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startNewLookupButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    
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
        
        self.showTopView()
        
        MyExpDataManager.sharedInstance.clearVendorLookupData()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GenericCell")
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        self.selectedYear = df.string(from: Date())
        
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.normal)
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.highlighted)
        self.displayYear()
        
        self.selectVendorButton.setTitle(self.selectedVendorName, for: UIControl.State.normal)
        self.selectVendorButton.setTitle(self.selectedVendorName, for: UIControl.State.highlighted)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideResultView()
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.selectYearButton.layer.cornerRadius = 5
        self.selectVendorButton.layer.cornerRadius = 5
        self.lookupButton.layer.cornerRadius = 5
        self.startNewLookupButton.layer.cornerRadius = 5
    }
    
    //MARK: - top view
    
    func showTopView() {
        let frame = self.topView.frame
        let vc = TopBarManager.sharedInstance.createTopHeader(frame: frame, title: "Vendor Lookup", isForAdmin: false)
        
        if vc != nil {
            vc!.delegate = self
            self.topView.addSubview(vc!.view)
            self.addChild(vc!)
        }
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
                self.showResultView()
                self.lookupTitlesList = MyExpDataManager.sharedInstance.lookupTitlesList
                self.lookupData = MyExpDataManager.sharedInstance.lookupData
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func chooseYearAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "monthAndYear", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SelectMonthAndYearViewController") as? SelectMonthAndYearViewController {
            vc.delegate = self
            vc.isForYearOnly = true
            vc.modalPresentationStyle = .fullScreen
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
    
    @IBAction func startNewLookupAction(_ sender: Any) {
        
        MyExpDataManager.sharedInstance.clearVendorLookupData()
        self.hideResultView()
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //MARK: - result view
    
    func showResultView() {
        self.resultView.isHidden = false
    }
    
    func hideResultView() {
        self.resultView.isHidden = true
    }
    
    func displayYear() {
        self.yearLabel.text = String(format: "( Year: %@ )", self.selectedYear)
        self.yearLabel.backgroundColor = UIColor.systemGray6
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.lookupTitlesList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let title = self.lookupTitlesList[section]
        let model = self.lookupData[title] ?? LookupModel()
        return model.exps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genericCell = self.tableView.dequeueReusableCell(withIdentifier: "GenericCell")
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell {
            cell.isForLookup = true
            
            let title = self.lookupTitlesList[indexPath.section]
            let model = self.lookupData[title] ?? LookupModel()
            let expsData = model.exps[indexPath.row]
            cell.displayModelData(data: expsData)
            return cell
        }
        else {
            return genericCell!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let title = self.lookupTitlesList[section]
        let model = self.lookupData[title] ?? LookupModel()
        return String(format: "%@ (total = %0.2f)", model.date, model.total)
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - delegates
    
    func cancelYearSelection() {
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
    
    func didSelectYear(isForYearOnly: Bool, selectedYear: String, selectedMonthIndex: String, selectedMonthText: String) {
        
        self.selectedYear = selectedYear
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.normal)
        self.selectYearButton.setTitle(self.selectedYear, for: UIControl.State.highlighted)
        self.displayYear()
        
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

extension VendorsLookupViewController: TopHeaderViewControllerDelegate {
    
    func goback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAdmin() {
        //
    }
}
