//
//  RecentSearchesTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/22/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class RecentSearchesTableViewCell: UITableViewCell {

    var recentSearch: RecentSearch?{
        didSet{
            queyLabel.text = recentSearch?.query
            locationLabel.text = recentSearch?.placeName
        }
    }
    
    @IBOutlet weak var queyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
