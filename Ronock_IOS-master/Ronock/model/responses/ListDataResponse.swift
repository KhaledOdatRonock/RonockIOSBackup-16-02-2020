//
//  ListDataResponse.swift
//  Ronock
//
//  Created by Khaled Odat on 11/18/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class ListDataResponse<T: Codable>: Codable{
    let continuationToken: String?
    let items: [T]?
}
