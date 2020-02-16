//
//  Story.swift
//  Ronock
//
//  Created by Khaled Odat on 1/6/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Story
struct Story: Codable {
    let id: Int
    let imageURL: String
    let type: Int
    let webURL: String
    let detailsImage: String?
    let advirtiserName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case type
        case webURL = "web_url"
        case detailsImage
        case advirtiserName = "advertiser_name"
    }
}
