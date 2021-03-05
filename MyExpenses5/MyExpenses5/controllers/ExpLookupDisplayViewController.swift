//
//  ExpLookupDisplayViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 8/22/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ExpLookupDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var myexpsList: [Expense] = []
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GenericCell")
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
    }
    
    //MARK: - top view
    
    func showTopView() {
        let storyboard = UIStoryboard(name: "topheader", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "TopHeaderViewController") as? TopHeaderViewController {
            let frame = self.topView.frame
            vc.view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            vc.delegate = self
            vc.headerTitle = "Expense Lookup"
            vc.isForAdmin = false
            self.topView.addSubview(vc.view)
            self.addChild(vc)
        }
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myexpsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genericCell = self.tableView.dequeueReusableCell(withIdentifier: "GenericCell")
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell {
            let model = self.myexpsList[indexPath.row]
            cell.isForLookup = true
            cell.displayModelData(data: model)
            return cell
        }
        return genericCell!
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ExpLookupDisplayViewController: TopHeaderViewControllerDelegate {
    
    func goback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAdmin() {
        //
    }
}
