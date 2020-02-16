//
//  Profile.swift
//  Ronock
//
//  Created by Khaled Odat on 11/27/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Profile
struct Profile: Codable {
    let fullName, firstName, lastName, email: String?
    let mobileNumber, imageURL: String?

    enum CodingKeys: String, CodingKey {
        case fullName, firstName, lastName, email, mobileNumber
        case imageURL = "imageUrl"
    }
}
