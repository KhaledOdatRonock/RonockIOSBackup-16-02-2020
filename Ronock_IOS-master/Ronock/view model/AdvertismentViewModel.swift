//
//  AdvertismentViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 1/22/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation

class AdvertismentViewModel {
    
   private var repository: Repository?
    
      // MARK: - Constructor
      init(repository: Repository) {
          self.repository = repository
      }
      
      // MARK: - Network call
      func addRecentSearch(recentSearch: RecentSearch) {
          self.repository?.addRecentSearch(recentSearch: recentSearch)
        }
}
