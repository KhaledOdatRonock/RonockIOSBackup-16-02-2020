//
//  ProfileListTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 11/27/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class ProfileListTableViewCell: UITableViewCell {
    
    var itemName: String?{
        didSet{
            self.listItemName.text = self.itemName ?? ""
        }
    }
    @IBOutlet weak var listItemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
