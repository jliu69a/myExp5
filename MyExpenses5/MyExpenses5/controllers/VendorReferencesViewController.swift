//
//  VendorReferencesViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 3/6/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit


protocol VendorReferencesViewControllerDelegate: AnyObject {
    func didSelectVendorReferenceAtIndex(index: Int)
}


class VendorReferencesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: VendorReferencesViewControllerDelegate?
    
    var vendorTitlesList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayTitles(list: [String]) {
        self.vendorTitlesList = list
        self.tableView.reloadData()
    }
}

extension VendorReferencesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vendorTitlesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VendorReferenceCell") as? VendorReferenceCell else {
            return UITableViewCell()
        }
        
        cell.displayTitle(index: indexPath.row, title: self.vendorTitlesList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.didSelectVendorReferenceAtIndex(index: indexPath.row)
    }
}
