//
//  DeviceInstallation.swift
//  Ronock
//
//  Created by Khaled Odat on 12/4/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

struct DeviceInstallation : Codable {
    let installationId : String
    let pushChannel : String
    let platform : String = "apns"
    var tags : [String]
    var templates : Dictionary<String, PushTemplate>

    init(withInstallationId installationId : String, andPushChannel pushChannel : String) {
        self.installationId = installationId
        self.pushChannel = pushChannel
        self.tags = [String]()
        self.templates = Dictionary<String, PushTemplate>()
    }
}
