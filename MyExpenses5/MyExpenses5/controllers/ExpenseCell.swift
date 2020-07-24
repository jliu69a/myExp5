//
//  ExpenseCell.swift
//  MyExps
//
//  Created by Johnson Liu on 1/14/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var cellVendorLabel: UILabel!
    @IBOutlet weak var cellNotesLabel: UILabel!
    @IBOutlet weak var cellAmountLabel: UILabel!
    @IBOutlet weak var cellPaymentLabel: UILabel!
    @IBOutlet weak var cellTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //-- rewrite
    func displayModelData(data: Expense) {

        self.cellVendorLabel.text = data.vendor ?? ""
        self.cellPaymentLabel.text = data.payment ?? ""
        self.cellNotesLabel.text = data.note ?? ""
        self.cellTimeLabel.text = String(format: "( time: %@ )", (data.time ?? ""))
        
        let amountText: String = data.amount ?? "0"
        let amountValue: Float = (amountText as NSString).floatValue
        self.cellAmountLabel.text = String(format: "%0.2f", amountValue)
        
        self.baseLabel.backgroundColor = UIColor.systemGray6
    }
    
    func colorForData() -> UIColor {
        
        let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return .white
            case .dark: return .black
            @unknown default:
                print("error in color.")
                return UIColor.clear
            }
        }
        
        return dynamicColor
    }
    
}
