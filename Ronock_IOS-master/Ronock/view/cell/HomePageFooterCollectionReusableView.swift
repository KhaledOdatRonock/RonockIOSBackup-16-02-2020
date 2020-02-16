//
//  HomePageFooterCollectionReusableView.swift
//  Ronock
//
//  Created by Khaled Odat on 12/10/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class HomePageFooterCollectionReusableView: UICollectionReusableView {
    var categoryID = -1
    
        override func awakeFromNib() {
               super.awakeFromNib()
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 5
            self.layer.borderWidth = 2
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
               // Initialization code
           }
}
