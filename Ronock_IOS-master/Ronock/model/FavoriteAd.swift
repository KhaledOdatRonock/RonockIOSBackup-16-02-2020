//
//  FavoriteAd.swift
//  Ronock
//
//  Created by Khaled Odat on 1/16/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - FavoriteAd
struct FavoriteAd: Codable {
    let itemID, type: Int
    let adLogo: String
    let advertiserName, adTitle, time, status: String

    enum CodingKeys: String, CodingKey {
        case itemID, type
        case adLogo = "ad_logo"
        case advertiserName = "advertiser_name"
        case adTitle = "ad_title"
        case time, status
    }
}
