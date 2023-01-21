//
//  DailyCheckCell.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 1/20/23.
//  Copyright © 2023 Home Office. All rights reserved.
//

import UIKit

class DailyCheckCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    weak var parentClass: DailyCheckViewController?
    
    var rowIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.onOffSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayData(index: Int, value: String) {
        rowIndex = index
        dayLabel.text = String(format: "Day %d", (index + 1))
        
        let valueNumber = Int(value) ?? 0
        onOffSwitch.isOn = (valueNumber != 0)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        parentClass?.changeDailyCheck(index: rowIndex, value: (mySwitch.isOn ? "1" : "0"))
    }
}
