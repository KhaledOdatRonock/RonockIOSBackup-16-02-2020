//
//  AdvertiserProfile.swift
//  Ronock
//
//  Created by Khaled Odat on 12/8/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - AdvertiserProfile
struct AdvertiserProfile: Codable {
    let advertiserLogo: String
    let address, advertiserName: String
    let followings: Int
    let aboutAdvertiser: String
}
