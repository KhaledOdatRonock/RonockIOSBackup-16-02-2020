//
//  FavoriteAdsTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/16/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class FavoriteAdsTableViewCell: UITableViewCell {

    var ad: FavoriteAd?{
        didSet{
            self.adThumb.downloaded(from: ad?.adLogo ?? "")
            self.advertiserName.text = ad?.advertiserName
            self.adTitle.text = ad?.adTitle
        }
    }
    
    @IBOutlet weak var adThumb: UIImageView!
    @IBOutlet weak var advertiserName: UILabel!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
