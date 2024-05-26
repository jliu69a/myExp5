//
//  PAndVLookupDataViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 9/10/23.
//  Copyright © 2023 Home Office. All rights reserved.
//

import UIKit

class PAndVLookupDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearTotalLabel: UILabel!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    let viewModel = PAndVLookupViewModel()
    
    var selectedYear: String = "0"
    var selectedPAndVId: String = "0"
    var selectedItem: String = ""
    var isForPayment: Bool = false

    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = isForPayment ? "Payments Lookup" : "Vendors Lookup"
        
        viewModel.clearPAndVLookupData()
        
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
        
        self.yearLabel.text = String(format: "Year: %@,   %@", self.selectedYear, self.selectedItem)
        self.yearTotalLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressIndicator.startAnimating()
        showVendorsLookupData()
    }
    
    func showVendorsLookupData() {
        
        viewModel.PAndVLookupData(year: self.selectedYear, paymentAndVendorId: selectedPAndVId, isForPayment: isForPayment) { (any: Any) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.progressIndicator.stopAnimating()
                
                self.yearTotalLabel.text = String(format: "annual total = %@", self.viewModel.showInCurrencyFormat(value: self.viewModel.annualTotal))
                
                self.tableView.isHidden = self.viewModel.isEmpty
            }
        }
    }
    
}

extension PAndVLookupDataViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            headerView.contentView.backgroundColor = kHeaderBgColor
            headerView.textLabel?.textColor = kHeaderTextColor
        }
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
