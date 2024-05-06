//
//  DailyCheckViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 1/20/23.
//  Copyright © 2023 Home Office. All rights reserved.
//

import UIKit

class DailyCheckViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var resetAllButton: UIButton!
    
    let viewModel = DailyCheckViewModel()
    var checkingType = DailyCheckViewModel.CheckingTypes.forProstate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tableView.register(UINib(nibName: "DailyCheckCell", bundle: nil), forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 0.5
        
        viewModel.types = checkingType
        viewModel.retrieveDailyStatusData()
        tableView.reloadData()
        
        resetAllButton.layer.cornerRadius = 5
        
        titleLabel?.text = viewModel.displayDate
        
        dateTimeLabel?.text = "Now:  \(Date().dateToText(formate: "yyyy-MM-dd HH:mm:ss  (EEE)"))"
    }
    
    @IBAction func resetAllDataAction(_ sender: Any) {
        resetAllData()
    }
    
    func changeDailyCheck(index: Int, value: String) {
        viewModel.editDailyStatusData(index: index, value: value)
    }
    
    func resetAllData() {
        
        let alert = UIAlertController(title: "Warning", message: "It will delete all of the data.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
            self.viewModel.refreshDailyStatusData()
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension DailyCheckViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSectionis()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId") as? DailyCheckCell
        cell?.parentClass = self
        let valueText = viewModel.rowAtIndex(row: indexPath.row)
        cell?.displayData(index: indexPath.row, value: valueText)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
