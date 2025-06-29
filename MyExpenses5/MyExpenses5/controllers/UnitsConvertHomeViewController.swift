//
//  UnitsConvertHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 6/29/25.
//  Copyright © 2025 Home Office. All rights reserved.
//

import UIKit

class UnitsConvertHomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let rowsList = ["Celsius vs Fahrenheit", "Kilometer vs Miles", "Litters vs Gallons"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Units Convert"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.systemOrange.cgColor
        self.tableView.layer.borderWidth = 0.5
    }
}

//MARK: -

extension UnitsConvertHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellId") else {
            return UITableViewCell()
        }
        
        cell.textLabel!.text = rowsList[indexPath.row]
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
}

extension UnitsConvertHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "unitsConvert", bundle: nil)
            if let vc = storyboard.instantiateViewController(identifier: "CelsiusVsFahrenheitViewController") as? CelsiusVsFahrenheitViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}
