//
//  SheetTableViewCell.swift
//  MVVM_Starter_Project
//
//  Created by Saferoad on 7/16/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class SheetTableViewCell: UITableViewCell {
    
    var optionTitle: String? {
        didSet{
            if let o = optionTitle{
                optioTitleLabel.text = o
            }
        }
    }
    @IBOutlet weak var optioTitleLabel: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
