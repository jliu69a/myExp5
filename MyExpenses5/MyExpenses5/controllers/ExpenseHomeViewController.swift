//
//  ExpenseHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/17/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ExpenseHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var expsList: [Expense] = []
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        self.activityIndicator.startAnimating()
        self.myexpPreloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.dateLabel.text = MyExpDataManager.sharedInstance.showDate(date: Date())
        self.amountLabel.text = "Total($): 0.00"
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ExpenseCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell
        
        let model: Expense = self.expsList[indexPath.row]
        cell!.displayModelData(data: model)
        
        return cell!
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - get data
    
    func myexpPreloadData() {
        let selectedDate: Date = Date()
        
        MyExpDataManager.sharedInstance.myExpsData(selectedDate: selectedDate) { (any: Any) in
            DispatchQueue.main.async {
                self.expsList = any as! [Expense]
                self.displayAmount()
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func displayAmount() {
        var totalAmount: Float = 0
        
        if self.expsList.count > 0 {
            for each in self.expsList {
                let amountText: String = each.amount ?? "0"
                let amountValue: Float = (amountText as NSString).floatValue
                totalAmount += amountValue
            }
        }
        self.amountLabel.text = String(format: "Total($): %0.2f", totalAmount)
    }
    
}
