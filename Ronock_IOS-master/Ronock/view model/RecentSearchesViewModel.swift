//
//  RecentSearchesViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 1/22/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class RecentSearchesViewModel {
    // MARK: - Properties
      private var recentSearches: [RecentSearch]? {
          didSet {
              guard let p = recentSearches else { return }
              self.didFinishFetch?(p)
          }
      }
      var error: Error? {
          didSet { self.showAlertClosure?() }
      }
      var isLoading: Bool = false {
          didSet { self.updateLoadingStatus?() }
      }
      private var repository: Repository?
      
      // MARK: - Closures for callback, since we are not using the ViewModel to the View.
      var showAlertClosure: (() -> ())?
      var updateLoadingStatus: (() -> ())?
      var didFinishFetch: ((_ ads: [RecentSearch]) -> ())?
      
      // MARK: - Constructor
      init(repository: Repository) {
          self.repository = repository
      }
      
      // MARK: - Network call

    func fetchRecentSearches() {
        self.repository?.fetchAllRecentSearches(completion: {recents, err in
            self.recentSearches = recents
        })
      }
}
