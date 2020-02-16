//
//  TokenData.swift
//  Ronock
//
//  Created by Khaled Odat on 12/4/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

struct TokenData {

    let token : String
    let expiration : Int

    init(withToken token : String, andTokenExpiration expiration : Int) {
        self.token = token
        self.expiration = expiration
    }
}
