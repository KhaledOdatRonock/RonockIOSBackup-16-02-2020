//
//  ClippedSliceParams.swift
//  Ronock
//
//  Created by Khaled Odat on 11/21/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - ClippedSliceParams
public struct ClippedSliceParams: Codable {
    let advertiserID, advertiserName: String
    let advertiserLogo: String
    let sliceURL: String?
    let isClipped: Bool?
    let advertisementExpiryDate, advertisementID, sliceID, advertisementTitle: String
    
    enum CodingKeys: String, CodingKey {
        case advertiserID = "advertiserId"
        case advertiserName, advertiserLogo
        case advertisementExpiryDate = "advertisementExpiryDate"
        case advertisementID = "advertisementId"
        case advertisementTitle = "advertisementTitle"
        case sliceID = "sliceId"
        case sliceURL
        case isClipped
    }
}
