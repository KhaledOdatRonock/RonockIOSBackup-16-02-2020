//
//  NearbyAdsHorizontalCollectionViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/13/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class NearbyAdsHorizontalCollectionViewCell: UICollectionViewCell {
    var ad: MapLocation?{
        didSet{
            if ad?.adType == Enums.MapLocationsType.SINGLE_AD.rawValue {
                let currentAd = ad?.ads?[0]
                adImage.downloaded(from: currentAd?.advertiserLogo ?? "")
                advertiserName.text = currentAd?.advertiser
                adTitle.text = currentAd?.name
            }else if ad?.adType == Enums.MapLocationsType.MULTI_AD.rawValue{
                advertiserName.text = "Here Multi Ads"
                adTitle.text = ""
            }
        }
    }
    var cellIndex: Int?
    
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var advertiserName: UILabel!
    @IBOutlet weak var adTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        adImage.image = nil
        adTitle.text = ""
        advertiserName.text =  ""
    }
}
