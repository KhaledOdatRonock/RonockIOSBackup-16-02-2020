//
//  NotificationPayload.swift
//  Ronock
//
//  Created by Khaled Odat on 12/4/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

// MARK: - NotificationPayload
struct NotificationPayload: Codable {
    let titleEn, titleAr, messageEn, messageAr: String
}
