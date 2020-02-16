//
//  BrandsCollectionViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/20/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {
    
    var brand: Brand?{
        didSet{
            brandLogo.downloaded(from: brand?.logo ?? "")
            brandLogo.contentMode = .scaleToFill

            brandName.text = brand?.name
            if brand?.isSelected ?? false {
               self.checkMark.alpha = 1
               self.contentView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
           }else{
               self.checkMark.alpha = 0
               self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
        }
    }
    
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
