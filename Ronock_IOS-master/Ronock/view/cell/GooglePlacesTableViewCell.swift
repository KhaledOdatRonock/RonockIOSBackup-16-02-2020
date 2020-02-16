//
//  GooglePlacesTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/22/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import GooglePlaces

class GooglePlacesTableViewCell: UITableViewCell {

    var autoCompletePrediction: GMSAutocompletePrediction?{
        didSet{
            self.cityName.text = autoCompletePrediction?.attributedPrimaryText.string
            self.countryLabel.text = autoCompletePrediction?.attributedSecondaryText?.string
        }
    }
    
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
