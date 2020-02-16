//
//  Coupon.swift
//  Ronock
//
//  Created by Khaled Odat on 12/18/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Coupon
struct Coupon: Codable {
    let itemID, type, likes, shares: Int
    let views, expiryDays: Int
    let location: String
    let background: String
    let hasCoupon: Bool
    let couponThumb: String
    let remainingRedeems, totalRedeems: Int
    let couponExpiry, couponTitle: String
}
