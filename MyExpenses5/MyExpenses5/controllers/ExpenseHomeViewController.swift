//
//  ExpenseHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/17/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ExpenseHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChangeDateViewControllerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var expsList: [Expense] = []
    var selectedDate: Date = Date()
    var selectedExpense: Expense? = nil
    
    var changeDateVC: ChangeDateViewController? = nil
    var editExpenseVC: EditExpensesViewController? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        self.activityIndicator.startAnimating()
        self.myexpPreloadData()
        
        self.displayDate(date: self.selectedDate)
        self.amountLabel.text = "Total($): 0.00"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.selectedExpense = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //-- testing only
        //MyExpDataManager.sharedInstance.saveHomeTest()
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
        self.selectedExpense = self.expsList[indexPath.row]
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction( UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction) in
            //
            print("- ")
            print("- to delete, myexp ID = \(self.selectedExpense!.id!) ")
            print("- ")
        }) )
        
        alert.addAction( UIAlertAction(title: "Edit", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            //
            print("- ")
            print("- to edit, myexp ID = \(self.selectedExpense!.id!) ")
            print("- ")
            self.showAddEditPage(model: self.selectedExpense)
        }) )
        
        alert.addAction( UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil) )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - get data
    
    func myexpPreloadData() {
        
        MyExpDataManager.sharedInstance.myExpsData(selectedDate: self.selectedDate) { (any: Any) in
            DispatchQueue.main.async {
                self.expsList = any as! [Expense]
                self.displayAmount()
                self.displayDate(date: self.selectedDate)
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func myexpWithSelectedDate(date: Date) {
        
        MyExpDataManager.sharedInstance.myExpsWithDate(selectedDate: date) { (any: Any) in
            DispatchQueue.main.async {
                self.expsList = any as! [Expense]
                self.displayAmount()
                self.displayDate(date: date)
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
    
    func displayDate(date: Date) {
        self.dateLabel.text = MyExpDataManager.sharedInstance.showDate(date: date)
    }
    
    //MARK: - change data
    
    func showAddEditPage(model: Expense?) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "expenseHome", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "EditExpensesViewController") as? EditExpensesViewController {
            self.editExpenseVC = vc
            self.editExpenseVC!.selectedExpense = model
            //self.editExpenseVC!.delegate = self
            //self.navController!.pushViewController(self.editExpenseVC!, animated: true)
            self.navigationController?.pushViewController(self.editExpenseVC!, animated: true)
        }
    }
    
    //MARK: - IB functions
    
    @IBAction func changeDateAction(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard.init(name: "expenseHome", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ChangeDateViewController") as? ChangeDateViewController {
            self.changeDateVC = vc
            self.changeDateVC!.delegate = self
            self.changeDateVC!.currentDate = self.selectedDate
            self.present(self.changeDateVC!, animated: true, completion: nil)
        }
    }
    
    @IBAction func addExpenseAction(_ sender: Any) {
        self.showAddEditPage(model: nil)
    }
    
    //MARK: - delegate functions
    
    func cancelSelectDate() {
        self.closeChangeDateView()
    }
    
    func selectNewDate(date: Date) {
        
        self.selectedDate = date
        self.closeChangeDateView()
        
        self.myexpWithSelectedDate(date: self.selectedDate)
        self.activityIndicator.startAnimating()
    }
    
    func closeChangeDateView() {
        
        if self.changeDateVC != nil {
            self.changeDateVC!.dismiss(animated: true, completion: nil)
            self.changeDateVC = nil
        }
    }
    
}
