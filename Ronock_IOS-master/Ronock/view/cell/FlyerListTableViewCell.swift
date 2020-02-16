//
//  FlyerListTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 11/17/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class FlyerListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flyerName: UILabel!
    @IBOutlet weak var flyerThumb: UIImageView!
    
    var currentFlyer: Flyer? {
        didSet{
            if let flyer = self.currentFlyer {
                //TODO: fill out the cell info
                self.flyerName.text? = flyer.flyerTitle
                
                if let thumbURL = flyer.thumbnail {
                    self.flyerThumb.downloaded(from: thumbURL)
                }else{
                    self.flyerThumb.image = #imageLiteral(resourceName: "pizza")
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
