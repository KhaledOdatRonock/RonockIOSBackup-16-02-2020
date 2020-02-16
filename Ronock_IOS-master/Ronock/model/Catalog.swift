//
//  Catalog.swift
//  Ronock
//
//  Created by Khaled Odat on 11/12/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Catalog
struct Catalog: Codable {
    let id: Int
    let name, advertiser: String
    let imgThumb: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, advertiser
        case imgThumb = "img_thumb"
    }
}
