//
//  ExpensesLookupViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 8/9/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ExpensesLookupViewController: UIViewController {
    let appDele = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lookupTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var amountTotalLabel: UILabel!
    
    let maxDayNumber: Int = 42
    let viewModel = ExpsLookupViewModel()
    
    var lookupYear = "0"
    var lookupMonth = "0"
    var lookupMonthText = ""
    
    var lookupYearValue: Int = 0
    var lookupMonthValue: Int = 0
    
    var totalDaysOfMonth: Int = 0
    var dayOfWeek: Int = 0
    var firstDayIndex: Int = 0
    
    var selectVC: SelectMonthAndYearViewController? = nil
    var displayLookupVC: ExpLookupDisplayViewController? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Expense Lookup"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.collectionView.backgroundColor = UIColor.systemGray6
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "GenericCellId")
        self.collectionView.register(UINib(nibName: "ExpLookupCell", bundle: nil), forCellWithReuseIdentifier: "CellId")
        
        progressIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lookupYearValue = Int(lookupYear) ?? 0
        lookupMonthValue = Int(lookupMonth) ?? 0
        lookupTitle.text = "for: \(lookupMonthText) \(lookupYear)"
        
        amountTotalLabel.text = ""
        
        monthInfo()
        
        self.collectionView.layer.borderColor = UIColor.systemOrange.cgColor
        self.collectionView.layer.borderWidth = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myexpWithYearAndMonth(year: lookupYear, month: lookupMonth)
    }
    
    //MARK: - get data
    
    func myexpWithYearAndMonth(year: String, month: String) {
        
        viewModel.expsLookupData(year: year, month: month) { (any: Any) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.progressIndicator.stopAnimating()
                
                let myDouble = self.viewModel.amountTotal
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                currencyFormatter.locale = Locale.current
                let priceString = currencyFormatter.string(from: NSNumber(value: myDouble)) ?? "0.00"
                self.amountTotalLabel.text = "total amount: \(priceString)"
            }
        }
    }
    
    //MARK: - heplers
    
    func monthInfo() {
        
        let dateComponents = DateComponents(year: lookupYearValue, month: lookupMonthValue)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents) ?? Date()

        if let range = calendar.range(of: .day, in: .month, for: date) {
            self.totalDaysOfMonth = range.count
        }
        
        //-- 1 : Sunday
        //-- 7 : Saturday
        let yearMonthDisplay = String(format: "%@-%@", lookupYear, lookupMonth)
        let selectedDate = Date().textToDate(format: appDele.dateFormat, dateText: "\(yearMonthDisplay)-01")
        
        self.dayOfWeek = Calendar.current.component(.weekday, from: selectedDate)
        self.firstDayIndex = self.dayOfWeek - 1
    }
    
    func displayForCell(cellIndex: Int) -> String {
        
        if cellIndex < self.firstDayIndex {
            return ""
        }
        
        let dayValue = cellIndex - self.firstDayIndex + 1
        var dayDisplay = ""
        
        if dayValue <= self.totalDaysOfMonth {
            dayDisplay = "\(cellIndex - self.firstDayIndex + 1)"
        }
        return dayDisplay
    }
    
    func dataForSelectedDate(day: String) {
        let modelsList = viewModel.lookupData[day] ?? []
        
        let storyboard = UIStoryboard(name: "monthAndYear", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ExpLookupDisplayViewController") as? ExpLookupDisplayViewController {
            vc.myexpsList = modelsList
            vc.selectedDate = "\(lookupMonthText) \(day), \(lookupYear)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: -

extension ExpensesLookupViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.maxDayNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genericCell: UICollectionViewCell? = self.collectionView.dequeueReusableCell(withReuseIdentifier: "GenericCellId", for: indexPath)
        
        if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as? ExpLookupCell {
            cell.parentVC = self
            cell.contentView.backgroundColor = UIColor.systemBackground
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 0.5
            
            let day = self.displayForCell(cellIndex: indexPath.row)
            var isActive: Bool = false
            var isWithData: Bool = false
            
            if day.count > 0 {
                isActive = true
                isWithData = viewModel.lookupDaysList.contains(day)
            }
            cell.showCellData(index: indexPath.row, date: day, isWithData: isWithData, isActive: isActive)
            
            return cell
        }
        
        genericCell!.contentView.backgroundColor = UIColor.systemBackground
        genericCell!.contentView.layer.borderColor = UIColor.black.cgColor
        genericCell!.contentView.layer.borderWidth = 0.5
        return genericCell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
