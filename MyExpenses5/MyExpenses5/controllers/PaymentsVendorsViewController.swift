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


class PaymentsVendorsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!
    
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    var viewModel: PaymentVendorViewModel = PaymentVendorViewModel()
    
    var allPayments: [Payment] = []
    var allVendors: [Vendor] = []
    var vendorDisplayTitles: [String] = []
    var vendorDisplayData: [String: AnyObject] = [:]
    
    var isForPayments: Bool = true
    var isForAdmin: Bool = false
    
    var selectedId: String = "0"
    var selectedName: String = ""
    
    weak var delegate: PaymentsVendorsViewControllerDelegate?

    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.allPayments = self.appDele.paymentsList
        self.viewModel.allVendors = self.appDele.vendorsList
        self.viewModel.vendorDisplayTitles = self.appDele.vendorDisplayTitles
        self.viewModel.vendorDisplayData = self.appDele.vendorDisplayData
        self.viewModel.isForPayments = self.isForPayments
        self.viewModel.isForAdmin = self.isForAdmin
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GenericCell")
        self.tableView.register(UINib(nibName: "PAndVCell", bundle: nil), forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleLabel.text = self.isForPayments ? "Payment" : "Vendor"
        
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
    
    //MARK: - notification, delegate
    
    func toRefreshPage() {
        self.viewModel.allPayments = self.appDele.paymentsList
        self.viewModel.allVendors = self.appDele.vendorsList
        self.tableView.reloadData()
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
    
    //MARK: - helpers
    
    func showAddOrEditPage(isForNew: Bool, id: String, name: String) {
        
        let storyboard = UIStoryboard(name: "admins", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AdminPVAddEditViewController") as? AdminPVAddEditViewController {
            vc.delegate = self
            vc.isForPayment = self.isForPayments
            vc.idValue = id
            vc.nameValue = name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: -

extension PaymentsVendorsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSectionis()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? PAndVCell {
            let data = self.viewModel.rowAtIndex(indexPath: indexPath)
            cell.displayData(data: data, isForPayments: self.isForPayments)
            return cell
        }
        else {
            let generic = self.tableView.dequeueReusableCell(withIdentifier: "GenericCell")
            return generic!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.headerHeightForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.headerTitleForSection(section: section)
    }
}

//MARK: -

extension PaymentsVendorsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let data = self.viewModel.rowAtIndex(indexPath: indexPath)
        self.selectedId = data.id
        self.selectedName = data.name
        
        if self.isForAdmin {
            self.showOptions()
        }
        else {
            self.delegate?.didSelectItem(isForPayment: self.isForPayments, name: self.selectedName, id: self.selectedId)
            self.navigationController!.popViewController(animated: true)
        }
    }
}

//MARK: -

extension PaymentsVendorsViewController: AdminPVAddEditViewControllerDelegate {
    
    func didSaveChanges(isForPayment: Bool) {
        self.toRefreshPage()
    }
}
