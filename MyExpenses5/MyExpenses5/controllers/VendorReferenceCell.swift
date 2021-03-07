//
//  VendorReferenceCell.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 3/6/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit

class VendorReferenceCell: UITableViewCell {
    
    //-- not used
    
    @IBOutlet weak var topLineLabel: UILabel!
    @IBOutlet weak var refTitleLabel: UILabel!
    
    func displayTitle(index: Int, title: String) {
        self.refTitleLabel.text = title;
        self.topLineLabel.isHidden = (index != 0)
    }
}
