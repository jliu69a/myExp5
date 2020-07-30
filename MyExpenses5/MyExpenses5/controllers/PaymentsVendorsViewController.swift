//
//  PaymentsVendorsViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/19/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


protocol PaymentsVendorsViewControllerDelegate: AnyObject {
    func didSelectItem(isForPayment: Bool, name: String, id: String)
}


class PaymentsVendorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdminPVAddEditViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
    
    var allPayments: [Payment] = []
    var allVendors: [Vendor] = []
    var isForPayments: Bool = true
    var isForAdmin: Bool = false
    
    var selectedId: String = "0"
    var selectedName: String = ""
    
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
        self.showAddOrEditPage(isForNew: true, id: "0", name: "")
    }
    
    func showAddOrEditPage(isForNew: Bool, id: String, name: String) {
        
        let storyboard = UIStoryboard(name: "admins", bundle: nil)
        if let vc: AdminPVAddEditViewController = storyboard.instantiateViewController(withIdentifier: "AdminPVAddEditViewController") as? AdminPVAddEditViewController {
            vc.delegate = self
            vc.isForPayment = self.isForPayments
            vc.idValue = id
            vc.nameValue = name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - notification, delegate
    
    @objc func refreshAfterChanges() {
        self.allPayments = MyExpDataManager.sharedInstance.paymentList
        self.allVendors = MyExpDataManager.sharedInstance.vendorList
        self.tableView.reloadData()
    }
    
    func didSaveChanges(isForPayment: Bool) {
        self.toRefreshPage()
    }
    
    func toRefreshPage() {
        self.allPayments = MyExpDataManager.sharedInstance.paymentList
        self.allVendors = MyExpDataManager.sharedInstance.vendorList
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
        
        if self.isForPayments == true {
            let item: Payment = self.allPayments[indexPath.row]
            self.selectedId = item.id!
            self.selectedName = item.payment!
        }
        else {
            let key: String = MyExpDataManager.sharedInstance.vendorDisplayTitles[indexPath.section]
            if indexPath.section == 0 {
                let array: [Top10] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Top10]) ?? []
                let item: Top10 = array[indexPath.row]
                self.selectedId = item.id!
                self.selectedName = item.vendor!
            }
            else {
                let array: [Vendor] = (MyExpDataManager.sharedInstance.vendorDisplayData[key] as? [Vendor]) ?? []
                let item: Vendor = array[indexPath.row]
                self.selectedId = item.id!
                self.selectedName = item.vendor!
            }
        }
        
        if self.isForAdmin == true {
            self.showOptions()
        }
        else {
            self.delegate?.didSelectItem(isForPayment: self.isForPayments, name: self.selectedName, id: self.selectedId)
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    //MARK: - alets
    
    func showOptions() {
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction( UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction) in
            self.toConfirmDelete()
        }) )
        
        alert.addAction( UIAlertAction(title: "Edit", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.toEdit()
        }) )
        
        alert.addAction( UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil) )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?) {
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction) in
            self.toProcessDelete()
        }) )
        
        alert.addAction( UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil) )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - alert actions
    
    func toEdit() {
        self.showAddOrEditPage(isForNew: false, id: self.selectedId, name: self.selectedName)
    }
    
    func toConfirmDelete() {
        let line: String = String(format: "Are you sure you want to delete '%@' (%@)?", self.selectedName, self.selectedId)
        self.showAlert(title: line, message: nil)
    }
    
    func toProcessDelete() {
        
        MyExpDataManager.sharedInstance.savePaymentsAndVendors(id: self.selectedId, name: self.selectedName, isForPayment: self.isForPayments, isEdit: false) { (any: Any) in
            DispatchQueue.main.async {
                let list: [String: AnyObject] = any as! [String: AnyObject]
                print("-> delete a payment/vendor, result array size = \(list.count) ")
                self.toRefreshPage()
            }
        }
    }
    
}

