//
//  CouponDetails.swift
//  Ronock
//
//  Created by Khaled Odat on 12/24/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - CouponDetails
struct CouponDetails: Codable {
    let thumbnail: String
    let title: String
    let expiryDays: Int
    let adPageURL: String
    let couponDetailsDescription: String
    let advertiserLogo: String

    enum CodingKeys: String, CodingKey {
        case thumbnail, title
        case expiryDays = "expiry_days"
        case adPageURL = "ad_page_url"
        case couponDetailsDescription = "description"
        case advertiserLogo = "advertiser_logo"
    }
}
