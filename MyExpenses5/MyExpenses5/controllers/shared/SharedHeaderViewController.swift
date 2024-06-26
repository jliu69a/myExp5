//
//  SharedHeaderViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 8/14/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit


//protocol SharedHeaderViewControllerDelegate: AnyObject {
//    func goback()
//}


class SharedHeaderViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    //weak var delegate: SharedHeaderViewControllerDelegate?
    
    var pageTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showData(title: String) {
        self.titleLabel.text = title
    }
    
//    @IBAction func gobackAction(_ sender: Any) {
//        self.delegate?.goback()
//    }
    
}
