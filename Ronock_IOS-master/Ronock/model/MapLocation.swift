//
//  MapLocation.swift
//  Ronock
//
//  Created by Khaled Odat on 12/30/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - MapLocation
struct MapLocation: Codable {
    let adType: Int?
    let longitude, latitude: String?
    var ads: [Ad]?
    var isSelected: Bool?
}
