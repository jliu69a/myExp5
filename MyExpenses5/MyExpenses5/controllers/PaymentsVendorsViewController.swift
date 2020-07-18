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
    func didSelectVendor(item: Vendor)
}


class PaymentsVendorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var allPayments: [Payment] = []
    var allVendors: [Vendor] = []
    var isForPayments: Bool = true
    
    weak var delegate: PaymentsVendorsViewControllerDelegate?

    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allPayments = MyExpDataManager.sharedInstance.paymentList
        self.allVendors = MyExpDataManager.sharedInstance.vendorList
        
        self.tableView.register(UINib(nibName: "PAndVCell", bundle: nil), forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isForPayments {
            self.titleLabel.text = "Payment"
        }
        else {
            self.titleLabel.text = "Vendor"
        }
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
    }
    
    //MARK: - IB action
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
//        if self.isForPayments {
//            return 1
//        }
//        else {
//            return DataManager.sharedInstance.vendorTop10GroupKeys!.count
//        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if self.isForPayments {
//            return self.rowsList!.count
//        }
//        else {
//            let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![section]
//            var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
//            if list == nil {
//                list = []
//            }
//            return list!.count
//        }
        
        if self.isForPayments {
            return self.allPayments.count
        }
        else {
            return self.allVendors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PAndVCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? PAndVCell
        
        if self.isForPayments {
            let item: Payment = self.allPayments[indexPath.row]
            cell!.nameLabel.text = item.payment ?? ""
            cell!.nameLabel.textColor = UIColor.black
            cell!.idLabel.text = item.id ?? "0"
            cell!.idLabel.textColor = UIColor.blue
        }
        else {
            let item: Vendor = self.allVendors[indexPath.row]
            cell!.nameLabel.text = item.vendor ?? ""
            cell!.nameLabel.textColor = UIColor.blue
            cell!.idLabel.text = item.id ?? "0"
            cell!.idLabel.textColor = UIColor.green
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
//        if self.isForPayments {
//            return 0
//        }
//        else {
//            //-- for vendors
//            if section == 0 {
//                let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![section]
//                let list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
//
//                //-- check for Top-10 listing
//                if list != nil && list!.count > 0 {
//                    return 30
//                }
//                else {
//                    return 0
//                }
//            }
//            else {
//                return 30
//            }
//        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        if self.isForPayments {
//            return nil
//        }
//        else {
//            return DataManager.sharedInstance.vendorTop10GroupKeys![section]
//        }
        
        return nil
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if self.isForPayments {
            self.delegate?.didSelectPayment(item: self.allPayments[indexPath.row])
        }
        else {
            self.delegate?.didSelectVendor(item: self.allVendors[indexPath.row])
        }
        
        self.navigationController!.popViewController(animated: true)
    }
}

