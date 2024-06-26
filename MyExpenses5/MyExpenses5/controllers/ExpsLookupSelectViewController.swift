//
//  ExpsLookupSelectViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 11/6/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit

class ExpsLookupSelectViewController: UIViewController {
    
    @IBOutlet weak var yearMonthBotton: UIButton!
    @IBOutlet weak var startLookupButton: UIButton!
    
    var selectVC: SelectMonthAndYearViewController? = nil
    
    var lookupYear = "0"
    var lookupMonth = "0"
    var lookupMonthText = ""
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Expense Lookup"
        
        lookupYear = Date().dateToText(formate: "yyyy")
        lookupMonth = Date().dateToText(formate: "MM")
        lookupMonthText = Date().dateToText(formate: "MMM")

        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        yearMonthBotton.layer.cornerRadius = 5
        startLookupButton.layer.cornerRadius = 5
        
        showYearAndMonth(display: String(format: "%@ %@", lookupMonthText, lookupYear))
    }
    
    //MARK: - IB actions
    
    @IBAction func chooseYearMonthAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "monthAndYear", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SelectMonthAndYearViewController") as? SelectMonthAndYearViewController {
            vc.delegate = self
            vc.isForYearOnly = false
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            self.selectVC = vc
        }
    }
    
    @IBAction func startLookupAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "expense", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "ExpensesLookupViewController") as? ExpensesLookupViewController {
            vc.lookupYear = lookupYear
            vc.lookupMonth = lookupMonth
            vc.lookupMonthText = lookupMonthText
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - helpers
    
    func showYearAndMonth(display: String) {
        yearMonthBotton.setTitle(display, for: UIControl.State.normal)
        yearMonthBotton.setTitle(display, for: UIControl.State.highlighted)
    }
}

//MARK: -

extension ExpsLookupSelectViewController: SelectMonthAndYearViewControllerDelegate {
    
    func cancelYearSelection() {
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
    
    func didSelectYear(isForYearOnly: Bool, selectedYear: String, selectedMonthIndex: String, selectedMonthText: String) {
        
        self.lookupYear = selectedYear
        self.lookupMonth = selectedMonthIndex
        self.lookupMonthText = selectedMonthText
        self.showYearAndMonth(display: String(format: "%@ %@", selectedMonthText, selectedYear))
        
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
}
