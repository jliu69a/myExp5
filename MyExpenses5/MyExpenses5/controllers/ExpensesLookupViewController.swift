//
//  ExpensesLookupViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 8/9/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ExpensesLookupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SelectMonthAndYearViewControllerDelegate {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var yearMonthBotton: UIButton!
    @IBOutlet weak var startLookupButton: UIButton!
    @IBOutlet weak var resultsView: UIView!
    
    @IBOutlet weak var lookupTitle: UILabel!
    @IBOutlet weak var clearResultsButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let maxDayNumber: Int = 42
    
    var selectedYear: Int = 0
    var selectedMonth: Int = 0
    var selectedMonthText: String = ""
    var yearMonthDisplay: String = ""
    
    var totalDaysOfMonth: Int = 0
    var dayOfWeek: Int = 0
    var firstDayIndex: Int = 0
    
    var expsLookupList: [Expense] = []
    var lookupDaysList: [String] = []
    var lookupData: [String: [Expense]] = [:]
    
    var selectVC: SelectMonthAndYearViewController? = nil
    var displayLookupVC: ExpLookupDisplayViewController? = nil
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showTopView()
        
        let rightNow = Date()
        let df = DateFormatter()
        
        df.dateFormat = "yyyy"
        let yearText = df.string(from: rightNow)
        self.selectedYear = Int(yearText) ?? 0
        
        df.dateFormat = "MM"
        let monthText = df.string(from: rightNow)
        self.selectedMonth = Int(monthText) ?? 0
        
        df.dateFormat = "MMM"
        self.selectedMonthText = df.string(from: rightNow)
        
        self.myexpWithYearAndMonth(year: yearText, month: monthText)
        
        self.yearMonthDisplay = String(format: "%@-%@", yearText, monthText)
        self.resultsView.backgroundColor = UIColor.systemGray6
        self.collectionView.backgroundColor = UIColor.systemGray6
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "GenericCellId")
        self.collectionView.register(UINib(nibName: "ExpLookupCell", bundle: nil), forCellWithReuseIdentifier: "CellId")
        
        self.hideResultsView()
        self.showYearAndMonth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.yearMonthBotton.layer.cornerRadius = 5
        self.startLookupButton.layer.cornerRadius = 5
        self.clearResultsButton.layer.cornerRadius = 5
        
        self.collectionView.layer.borderColor = UIColor.systemOrange.cgColor
        self.collectionView.layer.borderWidth = 0.5
        
    }
    
    //MARK: - top view
    
    func showTopView() {
        let storyboard = UIStoryboard(name: "topheader", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "TopHeaderViewController") as? TopHeaderViewController {
            let frame = self.topView.frame
            vc.view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            vc.delegate = self
            vc.headerTitle = "Expense Lookup"
            vc.isForAdmin = false
            self.topView.addSubview(vc.view)
            self.addChild(vc)
        }
    }
    
    //MARK: - get data
    
    func myexpWithYearAndMonth(year: String, month: String) {
        self.expsLookupList.removeAll()
        
        MyExpDataManager.sharedInstance.expsLookupData(year: year, month: month) { (any: Any) in
            DispatchQueue.main.async {
                self.expsLookupList = any as! [Expense]
                self.parseExpsLookupData()
            }
        }
    }
    
    func parseExpsLookupData() {
        
        self.lookupDaysList.removeAll()
        self.lookupData.removeAll()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let defaultDate = df.string(from: Date())
        
        for eachExp in self.expsLookupList {
            let dayText = (eachExp.date ?? defaultDate).suffix(2)
            let displayDay = "\(Int(dayText) ?? 0)"
            
            if !self.lookupDaysList.contains(displayDay) {
                self.lookupDaysList.append(displayDay)
            }
            
            var list = self.lookupData[displayDay] ?? []
            list.append(eachExp)
            self.lookupData[displayDay] = list
        }
        self.collectionView.reloadData()
    }
    
    //MARK: - collection view source
    
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
                isWithData = self.lookupDaysList.contains(day)
            }
            cell.showCellData(index: indexPath.row, date: day, isWithData: isWithData, isActive: isActive)
            print("-> index = \(indexPath.row), cell : '\(day)', is active? \(isActive), is with data? \(isWithData) ")
            
            return cell
        }
        
        genericCell!.contentView.backgroundColor = UIColor.systemBackground
        genericCell!.contentView.layer.borderColor = UIColor.black.cgColor
        genericCell!.contentView.layer.borderWidth = 0.5
        return genericCell!
    }
    
    //MARK: - collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        print("-> ")
        print("-> collection view, selected item at: section = \(indexPath.section), row = \(indexPath.row) ")
        print("-> ")
    }
    
    //MARK: - heplers
    
    func showYearAndMonth() {
        self.yearMonthBotton.setTitle(self.yearMonthDisplay, for: UIControl.State.normal)
        self.yearMonthBotton.setTitle(self.yearMonthDisplay, for: UIControl.State.highlighted)
    }
    
    func showResultsView() {
        self.resultsView.isHidden = false
    }
    
    func hideResultsView() {
        self.resultsView.isHidden = true
    }
    
    func monthInfo() {
        
        let dateComponents = DateComponents(year: self.selectedYear, month: self.selectedMonth)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        self.totalDaysOfMonth = range.count
        print("> ")
        print("> display as '\(self.yearMonthDisplay)', total days of month = \(self.totalDaysOfMonth)")
        print("> ")
        
        //-- 1 : Sunday
        //-- 7 : Saturday
        let firstDayOfMonth = "\(self.yearMonthDisplay)-01"
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let selectedDate = df.date(from: firstDayOfMonth) ?? Date()
        
        self.dayOfWeek = Calendar.current.component(.weekday, from: selectedDate)
        self.firstDayIndex = self.dayOfWeek - 1
        
        let totalDaysAhead: Int = self.dayOfWeek - 1
        print("- ")
        print("- date = \(selectedDate), the day of week is : \(self.dayOfWeek), total days ahead = \(totalDaysAhead) ")
        print("- ")
        
        self.collectionView.reloadData()
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
        let modelsList = self.lookupData[day] ?? []
        
        let storyboard = UIStoryboard(name: "monthAndYear", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ExpLookupDisplayViewController") as? ExpLookupDisplayViewController {
            vc.myexpsList = modelsList
            //self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - IB functions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseYearMonthAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "monthAndYear", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SelectMonthAndYearViewController") as? SelectMonthAndYearViewController {
            vc.delegate = self
            vc.isForYearOnly = false
            vc.modalPresentationStyle = .fullScreen
            self.selectVC = vc
            self.present(self.selectVC!, animated: true, completion: nil)
        }
    }
    
    @IBAction func startLookupAction(_ sender: Any) {
        
        self.showResultsView()
        self.lookupTitle.text = String(format: "for: %@ %d", self.selectedMonthText, self.selectedYear)
        
        //-- w : 43 x 7 = 301
        //-- h : 66 x 6 = 396
        
        self.monthInfo()
    }
    
    @IBAction func clearResultsAction(_ sender: Any) {
        self.hideResultsView()
    }
    
    //MARK: - delegates
    
    func cancelYearSelection() {
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
    
    func didSelectYear(isForYearOnly: Bool, selectedYear: String, selectedMonthIndex: String, selectedMonthText: String) {
        self.myexpWithYearAndMonth(year: selectedYear, month: selectedMonthIndex)
        
        self.selectedYear = Int(selectedYear) ?? 0
        self.selectedMonth = Int(selectedMonthIndex) ?? 0
        self.selectedMonthText = selectedMonthText
        
        self.yearMonthDisplay = String(format: "%@-%@", selectedYear, selectedMonthIndex)
        self.showYearAndMonth()
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
    
}

extension ExpensesLookupViewController: TopHeaderViewControllerDelegate {
    
    func goback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAdmin() {
        //
    }
}
