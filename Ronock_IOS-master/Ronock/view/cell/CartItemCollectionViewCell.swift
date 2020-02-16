//
//  CartItemCollectionViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 11/17/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class CartItemCollectionViewCell: UICollectionViewCell {
    
    var cartItem: ClippedItem?{
        didSet{
            if let item = cartItem {
                self.itemImage.downloaded(from: item.sliceUrl ?? "")
            }
        }
    }
    
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
