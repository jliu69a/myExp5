//
//  FilmsCell.swift
//  MyExpenses5
//
//  Created by Johnson Liu on 4/4/21.
//  Copyright © 2021 Home Office. All rights reserved.
//

import UIKit


class FilmsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearGenreLable: UILabel!
    @IBOutlet weak var watchTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func displayData(title: String, year: String, genre: String, watchDate: Date) {
        
        self.titleLabel.text = title
        self.yearGenreLable.text = "\(year) (\(genre))"
        self.watchTimeLabel.text = watchDate.dateAndTimetoString()
    }
    
}
