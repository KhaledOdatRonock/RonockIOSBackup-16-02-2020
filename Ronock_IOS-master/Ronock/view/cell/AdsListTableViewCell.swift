//
//  AdsListTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 11/5/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class AdsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var advLogo: UIImageView!
    @IBOutlet weak var adName: UILabel!
    @IBOutlet weak var advName: UILabel!
    
    var currentAd: Ad? {
        didSet{
            if let ad = self.currentAd {
                //TODO: fill out the cell info
                self.advLogo.downloaded(from: ad.advertiserLogo ?? "")
                self.adName.text = ad.name
                self.advName.text = ad.advertiser
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.goToProfile))
                self.advLogo.isUserInteractionEnabled = true
                self.advLogo.addGestureRecognizer(tap)
                
            }
        }
    }
    
    var logoClicked: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func goToProfile() {
        print("Logo Clicked")
        self.logoClicked?()
    }
    
}
