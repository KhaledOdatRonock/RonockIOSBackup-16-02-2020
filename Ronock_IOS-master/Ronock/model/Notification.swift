//
//  Notification.swift
//  Ronock
//
//  Created by Khaled Odat on 12/23/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - Notification
struct Notification: Codable {
    let notificationID, type: Int
    let title, message: String
    var isRead: Bool
    let timestamp: String
}
