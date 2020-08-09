//
//  ExpensesLookupViewController.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 8/9/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ExpensesLookupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SelectMonthAndYearViewControllerDelegate {
    
    @IBOutlet weak var yearMonthBotton: UIButton!
    @IBOutlet weak var startLookupButton: UIButton!
    @IBOutlet weak var resultsView: UIView!
    
    @IBOutlet weak var lookupTitle: UILabel!
    @IBOutlet weak var clearResultsButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let maxDayNumber: Int = 42
    
    var yearMonthDisplay: String = ""
    
    var selectVC: SelectMonthAndYearViewController? = nil
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM"
        self.yearMonthDisplay = df.string(from: Date())
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideResultsView()
        self.showYearAndMonth()
        
        self.yearMonthBotton.layer.cornerRadius = 5
        self.startLookupButton.layer.cornerRadius = 5
        self.clearResultsButton.layer.cornerRadius = 5
        
        self.collectionView.layer.borderColor = UIColor.systemOrange.cgColor
        self.collectionView.layer.borderWidth = 0.5
        
    }
    
    //MARK: - collection view source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.maxDayNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell? = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        
        cell!.contentView.backgroundColor = UIColor.systemGreen
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 43, height: 45)
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
    
    //MARK: - IB functions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseYearMonthAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "moneyAndYear", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SelectMonthAndYearViewController") as? SelectMonthAndYearViewController {
            vc.delegate = self
            vc.isForYearOnly = false
            self.selectVC = vc
            self.present(self.selectVC!, animated: true, completion: nil)
        }
    }
    
    @IBAction func startLookupAction(_ sender: Any) {
        
        self.showResultsView()
        self.lookupTitle.text = String(format: "( data for : %@ )", self.yearMonthDisplay)
        
        //-- w : 43 x 7 = 301
        //-- h : 66 x 6 = 396
        
        
    }
    
    @IBAction func clearResultsAction(_ sender: Any) {
        self.hideResultsView()
    }
    
    //MARK: - delegates
    
    func cancelYearSelection() {
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
    
    func didSelectYear(isForYearOnly: Bool, selectedYear: String, selectedMonthIndex: String) {
        
        self.yearMonthDisplay = String(format: "%@-%@", selectedYear, selectedMonthIndex)
        self.showYearAndMonth()
        self.selectVC?.dismiss(animated: true, completion: nil)
    }
    
}
