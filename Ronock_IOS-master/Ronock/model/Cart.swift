//
//  Cart.swift
//  Ronock
//
//  Created by Khaled Odat on 12/5/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import RealmSwift

class Cart: Object {
    @objc dynamic var advertiserID: String?
    @objc dynamic var advertiserName: String?
    @objc dynamic var advertiserLogo: String?
    @objc dynamic var sliceId: String?
    @objc dynamic var clip: String?
    
    override static func primaryKey() -> String? {
        return "sliceId"
    }
}
