//
//  MyNotificationsTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 12/23/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class MyNotificationsTableViewCell: UITableViewCell {

    var notification: Notification?{
        didSet{
            titleTxt.text = notification?.title
            messageTxt.text = notification?.message
            
            if notification?.isRead ?? false {
                isReadIndicaator.alpha = 0
            }else{
                isReadIndicaator.alpha = 1
            }
        }
    }
    
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var messageTxt: UILabel!
    @IBOutlet weak var isReadIndicaator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
