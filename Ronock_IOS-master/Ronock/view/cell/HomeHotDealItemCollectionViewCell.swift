//
//  HomeHotDealItemCollectionViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/8/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class HomeHotDealItemCollectionViewCell: UICollectionViewCell {
    var deal: HomeAd?{
            didSet{
                self.adImage.downloaded(from: deal?.background ?? "")
                self.adTitle.text = deal?.couponTitle
                
                //TODO: user enums to get the UIImage for ad type
            }
        }
        
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var adType: UIImageView!
    @IBOutlet weak var adTitle: UILabel!
    
    var didSaveAdClicked: ((_ hotDeal: HomeAd?) -> ())?
    
    override func awakeFromNib() {
            super.awakeFromNib()
        
        }
       override func prepareForReuse() {
           super.prepareForReuse()
        self.adTitle.text = ""
        self.adImage.image = nil
        
       }
    @IBAction func saveAd(_ sender: Any) {
        didSaveAdClicked!(self.deal)
    }
    @IBAction func shareAd(_ sender: Any) {
        self.deal?.couponTitle.share()
    }
}
