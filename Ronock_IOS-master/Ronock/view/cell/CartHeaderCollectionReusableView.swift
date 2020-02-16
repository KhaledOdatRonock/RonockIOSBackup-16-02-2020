//
//  CartHeaderCollectionReusableView.swift
//  Ronock
//
//  Created by Khaled Odat on 11/17/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class CartHeaderCollectionReusableView: UICollectionReusableView {
    var cartHeader: CartHeader?{
        didSet{
            if let header = cartHeader{
                self.headerTitle.text = header.advertiserName
                self.headerLogo.downloaded(from: header.advertiserLogo ?? "")
            }
        }
    }
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
