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
    
    var filmViewModel: FilmsHomeViewModel = FilmsHomeViewModel()
    var viewModel: AdminHomeViewModel = AdminHomeViewModel()

    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Admin"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        filmViewModel.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        self.loadMyFilms()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        let appVersion = (Bundle.main.infoDictionary ?? [:])["CFBundleShortVersionString"] as? String ?? ""
        let build = (Bundle.main.infoDictionary ?? [:])["CFBundleVersion"] as? String ?? ""
        self.versionsLabel.text = String(format: "Version: %@,  Build: %@", appVersion, build)
    }
    
    //MARK: - my films list
    
    func loadMyFilms() {
        filmViewModel.loadingFilmData()
    }
    
    //MARK: - payment & vendor
    
    func showPaymentsAndVendors(isForPayment: Bool) {
        
        if let vc = MEStoryboard.pv.vc as? PaymentsVendorsViewController {
            vc.isForAdmin = true
            vc.pageTitle = isForPayment ? "Payment" : "Vendor"
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
        
        if let vc = MEStoryboard.expsLookupSelect.vc as? ExpsLookupSelectViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showdailyStatusCheck() {
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = kHeaderBgColor
            headerView.textLabel?.textColor = kHeaderTextColor
        }
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
                self.showdailyStatusCheck()
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

extension AdminHomeViewController: FilmsHomeViewModelDelegate {
    
    func didLoadFilmsData() {
        //
    }
}
