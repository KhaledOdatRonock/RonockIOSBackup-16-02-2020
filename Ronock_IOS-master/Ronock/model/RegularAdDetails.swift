//
//  RegularAdDetails.swift
//  Ronock
//
//  Created by Khaled Odat on 12/15/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - RegularAdDetails
struct RegularAdDetails: Codable {
    let thumbnail: String
    let videoURL: String
    let title: String
    let expiryDays: Int
    let adPageURL: String
    let regularAdDetailsDescription: String
    let advertiserLogo: String
    let hasCoupon: Bool
    let couponThumb: String
    let remainingRedeems, totalRedeems: Int
    let couponExpiry, couponTitle: String

    enum CodingKeys: String, CodingKey {
        case thumbnail
        case videoURL = "video_url"
        case title
        case expiryDays = "expiry_days"
        case adPageURL = "ad_page_url"
        case regularAdDetailsDescription = "description"
        case advertiserLogo = "advertiser_logo"
        case hasCoupon, couponThumb, remainingRedeems, totalRedeems, couponExpiry, couponTitle
    }
}
