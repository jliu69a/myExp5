//
//  ExpLookupCell.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 8/9/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ExpLookupCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    var selectedIndex: Int = 0
    var isActive: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showCellData(index: Int, date: String, isWithData: Bool, isActive: Bool) {
        self.dateLabel.text = date
        
        if isWithData == true {
            self.indicatorLabel.backgroundColor = UIColor.systemGreen
        }
        else {
            self.indicatorLabel.backgroundColor = UIColor.clear
        }
        
        self.selectedIndex = index
        self.isActive = isActive
    }
}
