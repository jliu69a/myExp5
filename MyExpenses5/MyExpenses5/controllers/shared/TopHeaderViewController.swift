//
//  TopHeaderViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 3/3/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit


protocol TopHeaderViewControllerDelegate: AnyObject {
    func goback()
    func showAdmin()
}


class TopHeaderViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var adminButton: UIButton!
    
    weak var delegate: TopHeaderViewControllerDelegate?
    
    var isForAdmin: Bool = false
    var headerTitle: String = ""
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.displayForAdmin()
    }
    
    func displayForAdmin() {
        self.titleLabel.text = self.headerTitle
        
        self.borderLabel.isHidden = !self.isForAdmin
        self.adminLabel.isHidden = !self.isForAdmin
        self.backLabel.isHidden = self.isForAdmin
    }
    
    //MARK : - IB functions
    
    @IBAction func gobackAction(_ sender: Any) {
        
        if self.isForAdmin {
            return
        }
        self.delegate?.goback()
    }
    
    @IBAction func toAdminAction(_ sender: Any) {
        
        if !self.isForAdmin {
            return
        }
        self.delegate?.showAdmin()
    }
}
