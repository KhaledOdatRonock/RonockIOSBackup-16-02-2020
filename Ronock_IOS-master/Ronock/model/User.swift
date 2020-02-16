//
//  User.swift
//  MVVM_Starter_Project
//
//  Created by Saferoad on 7/11/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object{
    @objc dynamic var userID: String? = UUID().uuidString
    @objc dynamic var firstname: String?
    @objc dynamic var age: String?
    
    override static func primaryKey() -> String? {
        return "userID"
    }
    
}
