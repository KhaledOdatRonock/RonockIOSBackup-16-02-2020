//
//  WebAPIResponse.swift
//  Ronock
//
//  Created by Khaled Odat on 11/12/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - WebAPIResponse
class WebAPIResponse<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T?
    let errors: [MyError]
}

// MARK: - Error
struct MyError: Codable {
    let key, value: String
}
