//
//  ExpenseHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/17/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ExpenseHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChangeDateViewControllerDelegate, EditExpensesViewControllerDelegate {
    
    //-- not used
    
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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GenericCell")
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        self.activityIndicator.startAnimating()
        self.myexpPreloadData()
        
        self.displayDate(date: self.selectedDate)
        self.amountLabel.text = "Total($): 0.00"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.selectedExpense = nil
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genericCell = self.tableView.dequeueReusableCell(withIdentifier: "GenericCell")
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell {
            cell.isForLookup = false
            
            let model = self.expsList[indexPath.row]
            cell.displayModelData(data: model)
            return cell
        }
        else {
            return genericCell!
        }
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.selectedExpense = self.expsList[indexPath.row]
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction( UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction) in
            self.confirmToDelete(data: self.selectedExpense!)
        }) )
        
        alert.addAction( UIAlertAction(title: "Edit", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
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
        
        let storyboard: UIStoryboard = UIStoryboard(name: "expense", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "EditExpensesViewController") as? EditExpensesViewController {
            self.editExpenseVC = vc
            self.editExpenseVC!.selectedExpense = model
            self.editExpenseVC!.delegate = self
            //self.navController!.pushViewController(self.editExpenseVC!, animated: true)
            self.navigationController?.pushViewController(self.editExpenseVC!, animated: true)
        }
    }
    
    func confirmToDelete(data: Expense) {
        
        let title: String = String(format: "Do you want to delete the expense at: %@? \n\nwith amount of $%@ ?", data.vendor!, data.amount!)
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction( UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil) )
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            let actionCode: Int = MyExpDataManager.sharedInstance.kDeleteCode
            self.activityIndicator.startAnimating()
            
            MyExpDataManager.sharedInstance.saveMyexpsWithData(data: data, actionCode: actionCode)  { (any: Any) in
                DispatchQueue.main.async {
                    self.expsList = any as! [Expense]
                    self.displayAmount()
                    self.displayDate(date: self.selectedDate)
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.selectedExpense = nil
                }
            }
        }) )
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IB functions
    
    @IBAction func changeDateAction(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard.init(name: "expense", bundle: nil)
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
    
    @IBAction func showAdminsAction(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard.init(name: "admins", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AdminHomeViewController") as? AdminHomeViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    func didChangeExpenseData(data: Expense, selectedDate: Date, isForNew: Bool) {
        self.selectedExpense = nil
        
        let actionCode: Int = isForNew == true ? MyExpDataManager.sharedInstance.kInsertCode : MyExpDataManager.sharedInstance.kUpdateCode
        self.selectedDate = selectedDate
        self.activityIndicator.startAnimating()
        
        MyExpDataManager.sharedInstance.saveMyexpsWithData(data: data, actionCode: actionCode)  { (any: Any) in
            DispatchQueue.main.async {
                self.expsList = any as! [Expense]
                self.displayAmount()
                self.displayDate(date: self.selectedDate)
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}
