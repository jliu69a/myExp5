//
//  VendorsLookupDataViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/4/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit

class VendorsLookupDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    let viewModel = VendorsLookupViewModel()
    
    var selectedYear: String = "0"
    var selectedVendorId: String = "0"
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Vendors Lookup"
        
        viewModel.clearVendorLookupData()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.yearLabel.text = String(format: "( Year: %@ )", self.selectedYear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressIndicator.startAnimating()
        showVendorsLookupData()
    }
    
    func showVendorsLookupData() {
        viewModel.vendorsLookupData(year: self.selectedYear, vendorId: self.selectedVendorId) { (any: Any) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.progressIndicator.stopAnimating()
            }
        }
    }
    
}

extension VendorsLookupDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.lookupSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lookupItemForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell else {
            return UITableViewCell()
        }
        
        cell.isForLookup = true
        
        let expsData = viewModel.lookupData(indexPath: indexPath)
        cell.displayModelData(data: expsData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.lookupTitleForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .black
            headerView.textLabel?.textColor = .systemGreen
        }
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
