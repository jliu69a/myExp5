//
//  PAndVCell.swift
//  MyExps
//
//  Created by Johnson Liu on 1/19/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class PAndVCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func displayData(data: PAndVData, isForPayments: Bool) {
        self.nameLabel.text = data.name
        self.idLabel.text = data.displayId
        self.idLabel.textColor = isForPayments ? UIColor.blue : UIColor.orange
    }
}
