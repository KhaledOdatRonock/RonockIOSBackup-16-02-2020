//
//  PushTemplate.swift
//  Ronock
//
//  Created by Khaled Odat on 12/4/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

struct PushTemplate : Codable {
    let body : String

    init(withBody body : String) {
        self.body = body
    }
}
