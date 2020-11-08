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
    
    var changeDateVC: ChangeDateViewController? = nil
    var editExpenseVC: EditExpensesViewController? = nil
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GenericCell")
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        self.loadingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.amountLabel.text = viewModel.displayTotalAmount()
        self.dateLabel.text = viewModel.displayCurrentDate(date: self.selectedDate)
    }
    
    //MARK: - helpers
    
    func loadingData() {
        self.viewModel.loadingData(date: self.selectedDate)
        self.activityIndicator.startAnimating()
    }
    
    func showAddEditPage(model: Expense?) {
        //
    }
    
    //MARK: - IB actions
    
    @IBAction func adminAction(_ sender: Any) {
        self.showAddEditPage(model: nil)
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        
        if let vc = MEStoryboard.home(MEHomePage.changeDate).vc as? ChangeDateViewController {
            vc.currentDate = self.selectedDate
            vc.delegate = self
            self.changeDateVC = vc
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func createNewAction(_ sender: Any) {
        //
    }
}


extension MyExpHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSectionis()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell {
            if let data = self.viewModel.rowAtIndex(index: indexPath.row) {
                cell.displayModelData(data: data)
            }
            return cell
        }
        else {
            let genericCell = self.tableView.dequeueReusableCell(withIdentifier: "GenericCell")
            return genericCell!
        }
    }
}


extension MyExpHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = self.viewModel.rowAtIndex(index: indexPath.row) {
            self.selectedExpense = data
        }
        
        //-- show alert here
        
        self.showAddEditPage(model: self.selectedExpense)
    }
}


extension MyExpHomeViewController: ExpsHomeViewModelDelegate {
    
    //-- view model delegates
    
    func didLoadExpensesData() {
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        
        self.amountLabel.text = viewModel.displayTotalAmount()
        self.dateLabel.text = viewModel.displayCurrentDate(date: self.selectedDate)
    }
}


extension MyExpHomeViewController: ChangeDateViewControllerDelegate {
    
    //-- date change delegates
    
    func cancelSelectDate() {
        self.closeChangeDateView()
    }
    
    func selectNewDate(date: Date) {
        self.selectedDate = date
        self.closeChangeDateView()
        self.loadingData()
    }
    
    func closeChangeDateView() {
        if self.changeDateVC != nil {
            self.changeDateVC!.dismiss(animated: true, completion: nil)
            self.changeDateVC = nil
        }
    }
}
