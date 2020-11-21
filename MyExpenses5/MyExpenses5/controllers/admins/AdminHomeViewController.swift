//
//  AdminHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/24/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class AdminHomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionsLabel: UILabel!
    
    var viewModel: AdminHomeViewModel = AdminHomeViewModel()

    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GenericCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        self.versionsLabel.backgroundColor = UIColor.systemGray6
        self.versionsLabel.text = String(format: "Version: %@,  Build: %@", appVersion!, build!)
    }
    
    //MARK: - IB Actions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - payment & vendor
    
    func showPaymentsAndVendors(isForPayment: Bool) {
        
        let storyboard = UIStoryboard(name: "pandv", bundle: nil)
        if let vc: PaymentsVendorsViewController = storyboard.instantiateViewController(withIdentifier: "PaymentsVendorsViewController") as? PaymentsVendorsViewController {
            vc.isForAdmin = true
            vc.isForPayments = isForPayment
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - lookups
    
    func showVendorsLookup() {
        
        let storyboard = UIStoryboard(name: "pandv", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "VendorsLookupViewController") as? VendorsLookupViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showExpenseLookup() {
        
        let storyboard = UIStoryboard(name: "expense", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ExpensesLookupViewController") as? ExpensesLookupViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension AdminHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSectionis()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") {
            cell.textLabel!.text = self.viewModel.rowAtIndex(section: indexPath.section, row: indexPath.row)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        }
        else {
            let generic = self.tableView.dequeueReusableCell(withIdentifier: "GenericCell")
            return generic!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.titleForSections(index: section)
    }
}


extension AdminHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.showPaymentsAndVendors(isForPayment: true)
            }
            else if indexPath.row == 1 {
                self.showPaymentsAndVendors(isForPayment: false)
            }
            break
        case 1:
            if indexPath.row == 0 {
                self.showVendorsLookup()
            }
            else if indexPath.row == 1 {
                self.showExpenseLookup()
            }
            break
        default:
            break
        }
    }
}


extension AdminHomeViewController: PaymentsVendorsViewControllerDelegate {
    
    func didSelectItem(isForPayment: Bool, name: String, id: String) {
        if isForPayment == true {
            print("- ")
            print("- from admin, selected payment, id = \(id), name = '\(name)' ")
            print("- ")
        }
        else {
            print("- ")
            print("- from admin, selected vendor, id = \(id), name = '\(name)' ")
            print("- ")
        }
    }
}
