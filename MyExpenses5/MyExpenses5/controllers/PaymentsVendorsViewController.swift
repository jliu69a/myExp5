//
//  PaymentsVendorsViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/19/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


protocol PaymentsVendorsViewControllerDelegate: AnyObject {
    
    func didSelectPayment(item: Payment)
    func didSelectVendor(name: String, id: String)
}


class PaymentsVendorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
    
    var allPayments: [Payment] = []
    var allVendors: [Vendor] = []
    var isForPayments: Bool = true
    var isForAdmin: Bool = false
    
    weak var delegate: PaymentsVendorsViewControllerDelegate?

    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allPayments = MyExpDataManager.sharedInstance.paymentList
        self.allVendors = MyExpDataManager.sharedInstance.vendorList
        
        self.tableView.register(UINib(nibName: "PAndVCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAfterChanges), name: NSNotification.Name(rawValue: MyExpDataManager.sharedInstance.kPaymentsAndVendorsPageRefreshNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isForPayments {
            self.titleLabel.text = "Payment"
        }
        else {
            self.titleLabel.text = "Vendor"
        }
        
        if self.isForAdmin == true {
            self.tableViewBottomSpace.constant = 64
        }
        else {
            self.tableViewBottomSpace.constant = 10
        }
        self.addNewButton.layer.cornerRadius = 5
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
    }
    
    //MARK: - IB action
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func addNewAction(_ sender: Any) {
        //-- admin only
        let emptyIndex: IndexPath = IndexPath(item: 0, section: 0)
        self.showAddOrEditPage(isForNew: true, indexPath: emptyIndex)
    }
    
    func showAddOrEditPage(isForNew: Bool, indexPath: IndexPath) {
        var idValue: String = "ID: 0"
        var nameValue: String = ""
        
        if isForNew == false {
            if self.isForPayments == true {
                let item: Payment = self.allPayments[indexPath.row]
                idValue = String(format: "ID: %@", item.id!)
                nameValue = item.payment!
            }
            else {
                let key: String = MyExpDataManager.sharedInstance.vendorDisplayTitles[indexPath.section]
                if indexPath.section == 0 {
                    let array: [Top10] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Top10]) ?? []
                    let item: Top10 = array[indexPath.row]
                    idValue = String(format: "ID: %@", item.id!)
                    nameValue = item.vendor!
                }
                else {
                    let array: [Vendor] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Vendor]) ?? []
                    let item: Vendor = array[indexPath.row]
                    idValue = String(format: "ID: %@", item.id!)
                    nameValue = item.vendor!
                }
            }
        }
        
        let storyboard = UIStoryboard(name: "admins", bundle: nil)
        if let vc: AdminPVAddEditViewController = storyboard.instantiateViewController(withIdentifier: "AdminPVAddEditViewController") as? AdminPVAddEditViewController {
            vc.isForPayment = self.isForPayments
            vc.idValue = idValue
            vc.nameValue = nameValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - notification
    
    @objc func refreshAfterChanges() {
        self.tableView.reloadData()
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.isForPayments == true {
            return 1
        }
        else {
            return MyExpDataManager.sharedInstance.vendorDisplayTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isForPayments == true {
            return self.allPayments.count
        }
        else {
            let key: String = MyExpDataManager.sharedInstance.vendorDisplayTitles[section]
            if section == 0 {
                let array: [Top10] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Top10]) ?? []
                return array.count
            }
            else {
                let array: [Vendor] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Vendor]) ?? []
                return array.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PAndVCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? PAndVCell
        
        if self.isForPayments {
            let item: Payment = self.allPayments[indexPath.row]
            cell!.nameLabel.text = item.payment ?? ""
            cell!.idLabel.text = item.id ?? "0"
            cell!.idLabel.textColor = UIColor.blue
        }
        else {
            let key: String = MyExpDataManager.sharedInstance.vendorDisplayTitles[indexPath.section]
            
            if indexPath.section == 0 {
                let array: [Top10] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Top10]) ?? []
                let item: Top10 = array[indexPath.row]
                cell!.nameLabel.text = item.vendor ?? ""
                
                let totalCount: String = item.total ?? "0"
                cell!.idLabel.text = String(format: "%@, total = %@", (item.id ?? "0"), totalCount)
            }
            else {
                let array: [Vendor] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Vendor]) ?? []
                let item: Vendor = array[indexPath.row]
                cell!.nameLabel.text = item.vendor ?? ""
                cell!.idLabel.text = item.id ?? "0"
            }
            cell!.idLabel.textColor = UIColor.orange
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.isForPayments == true {
            return 0
        }
        else {
            let key: String = MyExpDataManager.sharedInstance.vendorDisplayTitles[section]
            let array: [AnyObject] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [AnyObject]) ?? []
            
            if array.count > 0 {
                return 40
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.isForPayments == true {
            return nil
        }
        else {
            return MyExpDataManager.sharedInstance.vendorDisplayTitles[section]
        }
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if self.isForAdmin == true {
            self.showAddOrEditPage(isForNew: false, indexPath: indexPath)
        }
        else {
            if self.isForPayments {
                self.delegate?.didSelectPayment(item: self.allPayments[indexPath.row])
            }
            else {
                var name: String = ""
                var id: String = ""
                
                let key: String = MyExpDataManager.sharedInstance.vendorDisplayTitles[indexPath.section]
                if indexPath.section == 0 {
                    let array: [Top10] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Top10]) ?? []
                    let item: Top10 = array[indexPath.row]
                    name = item.vendor ?? ""
                    id = item.id ?? "0"
                }
                else {
                    let array: [Vendor] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Vendor]) ?? []
                    let item: Vendor = array[indexPath.row]
                    name = item.vendor ?? ""
                    id = item.id ?? "0"
                }
                self.delegate?.didSelectVendor(name: name, id: id)
            }
            self.navigationController!.popViewController(animated: true)
        }
    }
}

