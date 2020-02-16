//
//  CustomInfoWindow.swift
//  Ronock
//
//  Created by Khaled Odat on 10/30/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {
    
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adContent: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var advLogo: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView(adObj: Ad) -> CustomInfoWindow{
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as! CustomInfoWindow
        customInfoWindow.adImage.image = adObj.adImageUIImage
        customInfoWindow.advLogo.image = adObj.advLogoUIImage
        
        customInfoWindow.adTitle.text = adObj.name
        customInfoWindow.adContent.text = adObj.advertiser
        return customInfoWindow
    }
}
