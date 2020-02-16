//
//  IntrestsUICollectionViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 11/27/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class IntrestsUICollectionViewCell: UICollectionViewCell {
    
    var intrestItem: Intrest?{
        didSet{
            if let item = intrestItem {
                self.intrestImage.downloaded(from: item.interestLogo)
                self.intrestName.text = item.interestName
                if item.isSelected {
                    self.tick.alpha = 1
                    self.contentView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                }else{
                    self.tick.alpha = 0
                    self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    @IBOutlet weak var intrestImage: UIImageView!
    @IBOutlet weak var intrestName: UILabel!
    @IBOutlet weak var tick: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
