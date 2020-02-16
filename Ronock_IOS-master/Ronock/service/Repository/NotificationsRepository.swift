//
//  NotificationsRepository.swift
//  Ronock
//
//  Created by Khaled Odat on 12/23/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

class NotificationsRepository {
    let remoteRepo: DataService = DataService.shared
      let localRepo: LocalStorage = LocalStorage.shared
      
      static let shared = NotificationsRepository();
      
    func fetchMyNotifications(continustionTOken: String, completion: @escaping (WebAPIResponse<ListDataResponse<Notification>>?, Error?) -> ()) {
          remoteRepo.fetchMyNotifications(continustionTOken: continustionTOken, completion: completion)
      }
      
}
