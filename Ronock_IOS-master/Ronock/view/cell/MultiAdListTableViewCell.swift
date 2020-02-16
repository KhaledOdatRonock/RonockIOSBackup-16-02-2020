//
//  MultiAdListTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 12/31/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class MultiAdListTableViewCell: UITableViewCell {
    var ad: Ad?{
        didSet{
            self.adThumb.downloaded(from: ad?.adImage ?? "")
            self.adThumb.contentMode = .scaleToFill
            self.advertiserLogo.downloaded(from: ad?.advertiserLogo ?? "")
            self.adTitle.text = ad?.name
            self.adDescription.text = ad?.advertiser
        }
    }
    
    @IBOutlet weak var adThumb: UIImageView!
    @IBOutlet weak var advertiserLogo: UIImageView!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
