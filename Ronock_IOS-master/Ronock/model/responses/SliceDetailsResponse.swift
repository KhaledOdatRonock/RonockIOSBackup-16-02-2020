//
//  SliceDetailsResponse.swift
//  Ronock
//
//  Created by Khaled Odat on 10/23/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - SliceDetailsResponse
struct SliceDetailsResponse: Codable {
    let brandGUID, year, flyerGUID, parentGUID: String
    let points: [String]
    let stream: JSONNull?
    let resourceName, resourceGUID: String
    let type: Int
    let resourceURL: String
    let metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        case brandGUID = "BrandGuid"
        case year = "Year"
        case flyerGUID = "FlyerGuid"
        case parentGUID = "ParentGuid"
        case points = "Points"
        case stream = "Stream"
        case resourceName = "ResourceName"
        case resourceGUID = "ResourceGuid"
        case type = "Type"
        case resourceURL = "ResourceUrl"
        case metadata = "Metadata"
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    
}
