//
//  ChooseDateViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 7/22/22.
//

import UIKit


protocol ChooseDateViewControllerDelegate: AnyObject {
    func selectNewDate(date: Date)
}


class ChooseDateViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    var selectedDate: Date = Date()
    
    weak var delegate: ChooseDateViewControllerDelegate?
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = String(format: "Today : %@", Date().dateToText(formate: "M/d, E"))
        datePicker.date = selectedDate
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datePicker.layer.borderColor = UIColor.black.cgColor
        datePicker.layer.borderWidth = 0.5
        
        self.todayButton.layer.cornerRadius = 5
        self.todayButton.clipsToBounds = true
        
        self.selectButton.layer.cornerRadius = 5
        self.selectButton.clipsToBounds = true
    }
    
    func closePage() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - IB functions
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        selectedDate = datePicker.date
    }
    
    @IBAction func chooseSelectedDate(_ sender: Any) {
        delegate?.selectNewDate(date: selectedDate)
        closePage()
    }
    
    @IBAction func chooseCurrentDate(_ sender: Any) {
        delegate?.selectNewDate(date: Date())
        closePage()
    }
}
