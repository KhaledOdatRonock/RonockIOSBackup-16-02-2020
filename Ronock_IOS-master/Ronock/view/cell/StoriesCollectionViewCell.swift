//
//  StoriesCollectionViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/6/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {
    var story: Story?{
         didSet{
            self.storyImage.downloaded(from: story?.imageURL ?? "")

         }
     }
     
    @IBOutlet weak var storyImage: UIImageView!
    override func awakeFromNib() {
         super.awakeFromNib()
        storyImage.layer.borderWidth = 3.0
        storyImage.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        storyImage.layer.masksToBounds = true
        
     }
    override func prepareForReuse() {
        super.prepareForReuse()
        storyImage.image = nil
    }
}
