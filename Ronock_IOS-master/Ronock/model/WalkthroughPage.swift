//
//  WalkthroughPage.swift
//  Ronock
//
//  Created by Khaled Odat on 1/9/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - WalkthroughPage
struct WalkthroughPage: Codable {
    let index: Int
    let imageURL: String
    let titleEn, descriptionEn: String

    enum CodingKeys: String, CodingKey {
        case index
        case imageURL = "image_url"
        case titleEn = "title_en"
        case descriptionEn = "description_en"
    }
}
