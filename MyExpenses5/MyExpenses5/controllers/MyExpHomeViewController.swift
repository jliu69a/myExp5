//
//  MyExpHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/8/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class MyExpHomeViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: ExpsHomeViewModel = ExpsHomeViewModel()
    var selectedDate: Date = Date()
    var selectedExpense: Expense? = nil
    
    var editExpenseVC: EditExpensesViewController? = nil
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MyExp"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Admin", style: .plain, target: self, action: #selector(showAdminPage))
        
        self.viewModel.delegate = self
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        self.loadingData()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(toReloadExpData), name: Notification.Name("NotificationForPaymentOrVendorChanges"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.amountLabel.text = viewModel.displayTotalAmount()
        self.dateLabel.text = HelpingTools().displayCurrentDate(date: self.selectedDate)
    }
    
    //MARK: - notification
    
    @objc func toReloadExpData() {
        self.loadingData()
    }
    
    //MARK: - bar button items
    
    @objc func showAdminPage() {
        if let vc = MEStoryboard.admin(MEAdminsPage.home).vc as? AdminHomeViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - IB actions
    
    @IBAction func selectDateAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "chooseDate", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ChooseDateViewController") as? ChooseDateViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func createNewAction(_ sender: Any) {
        self.showAddEditPage(model: nil)
    }
    
    //MARK: - helpers
    
    func loadingData() {
        self.viewModel.loadingData(date: self.selectedDate)
        self.activityIndicator.startAnimating()
    }
    
    func dataEditOptions() {
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction( UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction) in
            self.confirmToDelete(data: self.selectedExpense ?? Expense())
        }) )
        
        alert.addAction( UIAlertAction(title: "Edit", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.showAddEditPage(model: self.selectedExpense)
        }) )
        
        alert.addAction( UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil) )
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAddEditPage(model: Expense?) {
        
        if let vc = MEStoryboard.home(MEHomePage.saveExp).vc as? EditExpensesViewController {
            vc.delegate = self
            vc.isForNew = (model == nil)
            vc.pageTitle = (model == nil) ? "Add" : "Edit"
            vc.selectedDate = self.selectedDate
            
            vc.selectedExpense = model ?? Expense()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func confirmToDelete(data: Expense) {
        
        let title: String = String(format: "Do you want to delete the expense at: %@? \n\nwith amount of $%@ ?", (data.vendor ?? ""), (data.amount ?? ""))
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction( UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil) )
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.viewModel.savingData(data: data, actionCode: self.viewModel.kDeleteCode)
        }) )
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: -

extension MyExpHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSectionis()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell else {
            return UITableViewCell()
        }
        
        if let data = self.viewModel.rowAtIndex(index: indexPath.row) {
            cell.displayModelData(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = self.viewModel.rowAtIndex(index: indexPath.row) {
            self.selectedExpense = data
            self.dataEditOptions()
        }
    }
}

//MARK: -

extension MyExpHomeViewController: ExpsHomeViewModelDelegate {
    
    //-- view model delegates
    
    func didLoadExpensesData() {
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        
        self.amountLabel.text = viewModel.displayTotalAmount()
        self.dateLabel.text = HelpingTools().displayCurrentDate(date: self.selectedDate)
    }
}

//MARK: -

extension MyExpHomeViewController: ChooseDateViewControllerDelegate {
    
    func selectNewDate(date: Date) {
        self.selectedDate = date
        self.loadingData()
    }
}

//MARK: -

extension MyExpHomeViewController: EditExpensesViewControllerDelegate {
    
    func didChangeExpenseData(data: Expense, selectedDate: Date, isForNew: Bool, isDateChanged: Bool) {
        if isDateChanged {
            self.selectedDate = selectedDate
        }
        let actionCode = isForNew ? self.viewModel.kInsertCode : self.viewModel.kUpdateCode
        self.viewModel.savingData(data: data, actionCode: actionCode)
    }
}
