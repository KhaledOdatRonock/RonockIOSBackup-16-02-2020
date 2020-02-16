//
//  MapAdsResponse.swift
//  Ronock
//
//  Created by Khaled Odat on 10/31/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MapAdsResponse
struct MapListAdsResponse: Codable {
    let statusCode: Int
    let message: String
    let data: MapListAdsData
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message, data
    }
}

// MARK: - DataClass
struct MapListAdsData: Codable {
    let ads: [Ad]
    
    enum CodingKeys: String, CodingKey {
        case ads = "Ads"
    }
}

// MARK: - Ad
struct Ad: Codable {
    let id, type: Int?
    let discount, name, longitude, latitude: String?
    let advertiser: String?
    let advertiserLogo: String?
    let adImage: String?
    var adImageUIImage: UIImage? = nil
    var advLogoUIImage: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, type, discount, name, longitude, latitude, advertiser
        case advertiserLogo = "advertiser_logo"
        case adImage = "ad_image"
    }
}
