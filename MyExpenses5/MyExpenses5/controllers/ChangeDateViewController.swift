//
//  ChangeDateViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/15/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


/*
 *  not being used.
 */


protocol ChangeDateViewControllerDelegate: AnyObject {
    
    func cancelSelectDate()
    func selectNewDate(date: Date)
}


class ChangeDateViewController: UIViewController {
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ChangeDateViewControllerDelegate?
    
    var currentDate: Date = Date()
    //var df: DateFormatter = DateFormatter()
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.df.dateFormat = "M/d, E"
        self.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        if #available(iOS 14, *) {
            self.datePicker.preferredDatePickerStyle = .inline
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        self.datePicker.date = self.currentDate
        self.displayDate(currentDate: self.datePicker.date)
        
        self.todayButton.layer.cornerRadius = 5
        self.todayButton.clipsToBounds = true
        
        self.selectButton.layer.cornerRadius = 5
        self.selectButton.clipsToBounds = true
        
        self.datePicker.layer.borderColor = UIColor.systemGray4.cgColor
        self.datePicker.layer.borderWidth = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - IB actions
    
    @IBAction func setToTodayAction(_ sender: Any) {
        self.datePicker.date = Date()
        self.delegate?.selectNewDate(date: self.datePicker.date)
    }
    
    @IBAction func cancelDateSelectAction(_ sender: Any) {
        self.delegate?.cancelSelectDate()
    }
    
    @IBAction func selectPickerDateAction(_ sender: Any) {
        self.delegate?.selectNewDate(date: self.datePicker.date)
    }
    
    //MARK: - date picker
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        self.displayDate(currentDate: self.datePicker.date)
    }
    
    func displayDate(currentDate: Date) {
        self.titleLabel.text = String(format: "Date : %@", currentDate.dateToText(formate: "M/d, E"))
    }
    
}
