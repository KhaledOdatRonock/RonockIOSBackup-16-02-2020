//
//  MyCouponTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 12/18/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class MyCouponTableViewCell: UITableViewCell {

    var item: Coupon?{
          didSet{
            self.couponeImage.downloaded(from: item?.couponThumb ?? "")
            self.advertiserName.text = item?.couponTitle
            self.adTitle.text = item?.couponTitle
          }
      }
    @IBOutlet weak var couponeImage: UIImageView!
    @IBOutlet weak var advertiserName: UILabel!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
