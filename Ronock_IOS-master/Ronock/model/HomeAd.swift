//
//  Deal.swift
//  Ronock
//
//  Created by Khaled Odat on 12/9/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Deal
struct HomeAd: Codable {
    let itemID, type, likes, shares: Int
    let views, expiryDays: Int
    let location: String
    let background: String
    let hasCoupon: Bool
    let couponThumb: String
    let remainingRedeems, totalRedeems: Int
    let couponExpiry, couponTitle, advertiserName: String?
    let advertiserLogo: String?

    enum CodingKeys: String, CodingKey {
        case itemID, type, likes, shares, views, expiryDays, location, background, hasCoupon, couponThumb, remainingRedeems, totalRedeems, couponExpiry, couponTitle
        case advertiserName = "advertiser_name"
        case advertiserLogo = "advertiser_logo"
    }
}
