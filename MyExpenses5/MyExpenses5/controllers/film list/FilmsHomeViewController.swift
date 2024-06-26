//
//  FilmsHomeViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 4/4/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit

class FilmsHomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
    }
}
