//
//  CartHeader.swift
//  Ronock
//
//  Created by Khaled Odat on 11/14/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - CartHeader
struct CartHeader: Codable {
    let advertiserId: String?
    let advertiserName: String?
    let advertiserLogo: String?
    var clippedItem: [ClippedItem]?
    
    enum CodingKeys: String, CodingKey {
        case advertiserName, advertiserId
        case advertiserLogo = "advertiserLogo"
        case clippedItem = "clips"
    }
}

// MARK: - ClippedItem
struct ClippedItem: Codable {
    let advertisementId, advertisementExpiryDate, sliceId, sliceUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case advertisementId, advertisementExpiryDate, sliceId, sliceUrl
    }
}
