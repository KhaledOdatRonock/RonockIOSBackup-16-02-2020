//
//  Brand.swift
//  Ronock
//
//  Created by Khaled Odat on 1/20/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Brand
struct Brand: Codable {
    let id: Int
    let name: String
    let logo: String
    var isSelected: Bool?
}
