//
//  DealSection.swift
//  Ronock
//
//  Created by Khaled Odat on 12/9/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - DealSection
struct DealSection: Codable {
    let sectionID: Int
    let sectionName: String
    let sectionIcon: String
    let deals: [HomeAd]
    
    enum CodingKeys: String, CodingKey {
        case sectionID, sectionName, sectionIcon
        case deals = "items"
    }
}
