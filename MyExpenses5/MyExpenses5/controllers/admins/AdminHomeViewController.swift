//
//  AdminHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/24/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class AdminHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PaymentsVendorsViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionsLabel: UILabel!
    
    let titlesList: [String] = ["Settings", "Reports", "Misc"]
    let settingsList: [String] = ["Edit Payments", "Edit Vendors"]
    let reportsList: [String] = ["Expense Report", "Export Data"]
    let miscList: [String] = ["Look Up Vendor", "Look Up Expenses", "Location Check", "Device Info"]
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titlesList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalRows: Int = 0
        
        switch section {
        case 0:
            totalRows = self.settingsList.count
            break
        case 1:
            totalRows = self.reportsList.count
            break
        case 2:
            totalRows = self.miscList.count
            break
        default:
            break
        }
        return totalRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId")
        
        switch indexPath.section {
        case 0:
            cell!.textLabel!.text = self.settingsList[indexPath.row]
            break
        case 1:
            cell!.textLabel!.text = self.reportsList[indexPath.row]
            break
        case 2:
            cell!.textLabel!.text = self.miscList[indexPath.row]
            break
        default:
            break
        }
        cell!.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titlesList[section]
    }
    
    //MARK: - table view delegate
    
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
            break
        case 2:
            break
        default:
            break
        }
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
    
    func didSelectPayment(item: Payment) {
        //
        print("- ")
        print("- from admin, selected payment, id = \(item.id!), name = '\(item.payment!)' ")
        print("- ")
    }
    
    func didSelectVendor(name: String, id: String) {
        //
        print("- ")
        print("- from admin, selected vendor, id = \(id), name = '\(name)' ")
        print("- ")
    }

    
}
