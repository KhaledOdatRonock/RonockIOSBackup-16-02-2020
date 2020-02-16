//
//  UnClipSliceParams.swift
//  Ronock
//
//  Created by Khaled Odat on 11/25/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
// MARK: - UnClippedSliceParams
public struct UnClipSliceParams: Codable {
    let advertiserID: String
    let sliceID: String
    
    enum CodingKeys: String, CodingKey {
        case advertiserID = "advertiserId"
        case sliceID = "sliceId"
    }
}
