//
//  ViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 7/16/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var rowsList: [String] = []
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main"
        self.rowsList = ["One", "Two", "Three"]
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId")
        
        cell!.textLabel!.text = self.rowsList[indexPath.row]
        cell!.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell!
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

