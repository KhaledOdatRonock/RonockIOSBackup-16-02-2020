//
//  MyCouponsCollectionViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 12/24/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class MyCouponsCollectionViewCell: UICollectionViewCell {
    var coupon: Coupon?{
         didSet{
            myCouponThumbnail.downloaded(from: coupon?.background ?? "")
            myCouponTitle.text = coupon?.couponTitle
         }
     }
     
    
    @IBOutlet weak var myCouponThumbnail: UIImageView!
    @IBOutlet weak var myCouponTitle: UILabel!
    override func awakeFromNib() {
         super.awakeFromNib()
     }
}
