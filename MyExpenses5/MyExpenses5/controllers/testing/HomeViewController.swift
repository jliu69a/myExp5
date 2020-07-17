//
//  HomeViewController.swift
//  MyTest6
//
//  Created by Johnson Liu on 7/14/20.
//  Copyright © 2020 Johnson Liu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var totalSections: Int = 0
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        
        //self.rowsList = ["my expenses", "place holder 1", "place holder 2"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.myexpData()
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.totalSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalCells: Int = 0
        
        switch section {
        case DatasManager.sharedInstance.kExpenseCode:
            totalCells = MyExpDataManager.sharedInstance.expenseList.count
            break
        case DatasManager.sharedInstance.kTop10Code:
            totalCells = MyExpDataManager.sharedInstance.top10List.count
            break
        case DatasManager.sharedInstance.kPaymentCode:
            totalCells = MyExpDataManager.sharedInstance.paymentList.count
            break
        case DatasManager.sharedInstance.kVendorCode:
            totalCells = MyExpDataManager.sharedInstance.vendorList.count
            break
        default:
            break
        }
        
        return totalCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId")
        var line: String = ""
        
        switch indexPath.section {
        case DatasManager.sharedInstance.kExpenseCode:
            let exp: Expense = MyExpDataManager.sharedInstance.expenseList[indexPath.row]
            line = String(format: "$%@, %@, %@", exp.amount!, exp.date!, exp.time!)
            break
        case DatasManager.sharedInstance.kTop10Code:
            let top10: Top10 = MyExpDataManager.sharedInstance.top10List[indexPath.row]
            line = String(format: "%@, total = %@", top10.vendor!, top10.total!)
            break
        case DatasManager.sharedInstance.kPaymentCode:
            let payment: Payment = MyExpDataManager.sharedInstance.paymentList[indexPath.row]
            line = String(format: "%@ (%@)", payment.payment!, payment.id!)
            break
        case DatasManager.sharedInstance.kVendorCode:
            let vendor: Vendor = MyExpDataManager.sharedInstance.vendorList[indexPath.row]
            line = String(format: "%@ (%@)", vendor.vendor!, vendor.id!)
            break
        default:
            break
        }
        
        cell!.textLabel!.text = line
        cell!.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = ""
        
        switch section {
        case DatasManager.sharedInstance.kExpenseCode:
            title = "Expense"
            break
        case DatasManager.sharedInstance.kTop10Code:
            title = "Top 10"
            break
        case DatasManager.sharedInstance.kPaymentCode:
            title = "Payments"
            break
        case DatasManager.sharedInstance.kVendorCode:
            title = "Vendors"
            break
        default:
            break
        }
        
        return title
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - data
    
    func myexpData() {
        
        DatasManager.sharedInstance.myExpsData { (any: Any) in
            DispatchQueue.main.async {
                let myexpsList: [MyExpsData] = any as! [MyExpsData]
                
                self.totalSections = myexpsList.count
                for each in myexpsList {
                    if each.expense != nil {
                        MyExpDataManager.sharedInstance.expenseList = each.expense!
                    }
                    if each.payments != nil {
                        MyExpDataManager.sharedInstance.paymentList = each.payments!
                    }
                    if each.vendors != nil {
                        MyExpDataManager.sharedInstance.vendorList = each.vendors!
                    }
                    if each.top10 != nil {
                        MyExpDataManager.sharedInstance.top10List = each.top10!
                    }
                }
                print("- ")
                print("- total sections = \(myexpsList.count)")
                print("- expense count = \(MyExpDataManager.sharedInstance.expenseList.count) | payment count = \(MyExpDataManager.sharedInstance.paymentList.count) | top 10 count = \(MyExpDataManager.sharedInstance.top10List.count) | vendor count = \(MyExpDataManager.sharedInstance.vendorList.count) ")
                print("- ")
                
                self.tableView.reloadData()
                
                //self.allStatesData()
            }
        }
    }
    
    func allStatesData() {
        
        DatasManager.sharedInstance.statesData { (any: Any) in
            DispatchQueue.main.async {
                let statesList: [StatesData] = any as! [StatesData]
                print("- ")
                print("- all states array count = \(statesList.count)")
                print("- ")
            }
        }
    }
    
}
