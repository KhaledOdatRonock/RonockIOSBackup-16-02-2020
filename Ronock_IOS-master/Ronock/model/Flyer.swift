//
//  Flyer.swift
//  Ronock
//
//  Created by Khaled Odat on 11/18/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Flyer
struct Flyer: Codable {
    let advertiserID, campaignName, campaignID, flyerID: String
    let flyerTitle, flyerDescription: String
    let thumbnail: String?
    let dateFrom, dateTo: String
    let metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        case advertiserID = "advertiserId"
        case campaignName
        case campaignID = "campaignId"
        case flyerID = "flyerId"
        case flyerTitle, flyerDescription, thumbnail, dateFrom, dateTo, metadata
    }
}
