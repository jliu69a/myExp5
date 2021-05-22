//
//  AdminHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/24/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class AdminHomeViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionsLabel: UILabel!
    
    var filmViewModel: FilmsHomeViewModel = FilmsHomeViewModel()
    var viewModel: AdminHomeViewModel = AdminHomeViewModel()

    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmViewModel.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        
        self.showTopView()
        self.loadMyFilms()
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
    
    //MARK: - top view
    
    func showTopView() {
        let frame = self.topView.frame
        if let vc = TopBarManager.sharedInstance.createTopHeader(frame: frame, title: "Admin", isForAdmin: false) {
            vc.delegate = self
            self.topView.addSubview(vc.view)
            self.addChild(vc)
        }
    }
    
    //MARK: - my films list
    
    func loadMyFilms() {
        filmViewModel.loadingFilmData()
    }
    
    //MARK: - payment & vendor
    
    func showPaymentsAndVendors(isForPayment: Bool) {
        
        if let vc = MEStoryboard.pv.vc as? PaymentsVendorsViewController {
            vc.isForAdmin = true
            vc.isForPayments = isForPayment
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - lookups
    
    func showVendorsLookup() {
        
        if let vc = MEStoryboard.vendorLookup.vc as? VendorsLookupViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showExpenseLookup() {
        
        if let vc = MEStoryboard.expenseLookup.vc as? ExpensesLookupViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showLocationCheck() {
        //
    }
    
}

//MARK: -

extension AdminHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSectionis()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") else {
            return UITableViewCell()
        }
        
        cell.textLabel!.text = self.viewModel.rowAtIndex(section: indexPath.section, row: indexPath.row)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.titleForSections(index: section)
    }
}

//MARK: -

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
        case 2:
            if indexPath.row == 0 {
                self.showLocationCheck()
            }
            break
        default:
            break
        }
    }
}

//MARK: -

extension AdminHomeViewController: PaymentsVendorsViewControllerDelegate {
    
    func didSelectItem(isForPayment: Bool, name: String, id: String) {
        //
    }
}

extension AdminHomeViewController: TopHeaderViewControllerDelegate {
    
    func goback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAdmin() {
        //
    }
}

extension AdminHomeViewController: FilmsHomeViewModelDelegate {
    
    func didLoadFilmsData() {
        //
    }
}
