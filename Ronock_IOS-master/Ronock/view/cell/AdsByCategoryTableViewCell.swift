//
//  AdsByCategoryTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 12/15/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class AdsByCategoryTableViewCell: UITableViewCell {

    var item: HomeAd?{
        didSet{
            views.set(text: "\(item?.views ?? 0)", leftIcon: #imageLiteral(resourceName: "view"), rightIcon: nil)
            favs.set(text: "\(item?.likes ?? 0)", leftIcon: #imageLiteral(resourceName: "favorite-heart-button_16px").maskWithColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), rightIcon: nil)
            shares.set(text: "\(item?.shares ?? 0)", leftIcon: #imageLiteral(resourceName: "share").maskWithColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), rightIcon: nil)
            address.set(text: "\(item?.location ?? "")", leftIcon: #imageLiteral(resourceName: "placeholder").maskWithColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), rightIcon: nil)
            expiryDay.text = "Expired in \(item?.expiryDays ?? 0) days"
        }
    }
    @IBOutlet weak var expiryDay: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var favs: UILabel!
    @IBOutlet weak var shares: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var addToFav: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        addToFav.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
//        addToFav.setImage(#imageLiteral(resourceName: "favorite-heart-button"), for: .selected)
        // Configure the view for the selected state
    }

    @IBAction func addTofav(_ sender: Any) {
        let btn = sender as! UIButton
               
               if btn.isSelected {
                   btn.isSelected = false
               } else {
                   btn.isSelected = true
               }
    }
}
