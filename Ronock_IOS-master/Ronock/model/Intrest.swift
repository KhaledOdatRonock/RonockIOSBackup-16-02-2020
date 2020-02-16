//
//  Intrest.swift
//  Ronock
//
//  Created by Khaled Odat on 11/27/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Intrest
struct Intrest: Codable {
    let interestID: Int
    let interestName, interestNameResourceKey, interestDescription, interestDescriptionResourceKey: String
    let interestLogo: String
    var isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case interestID = "interestId"
        case interestName, interestNameResourceKey, interestDescription, interestDescriptionResourceKey, interestLogo, isSelected
    }
}
