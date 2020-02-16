//
//  RecentSearch.swift
//  Ronock
//
//  Created by Khaled Odat on 1/22/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - RecentSearch
class RecentSearch: Object{
    @objc dynamic var id = -1
    @objc dynamic var placeID: String?
    @objc dynamic var placeName: String?
    @objc dynamic var query: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
