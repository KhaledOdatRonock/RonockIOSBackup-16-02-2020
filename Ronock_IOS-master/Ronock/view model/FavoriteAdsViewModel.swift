//
//  FavoriteAdsViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 1/16/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class FavoriteAdsViewModel {
    // MARK: - Properties
       private var favAds: ListDataResponse<FavoriteAd>? {
           didSet {
               guard let p = favAds else { return }
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
       var didFinishFetch: ((_ ads: ListDataResponse<FavoriteAd>) -> ())?
       
       // MARK: - Constructor
       init(repository: Repository) {
           self.repository = repository
       }

    // MARK: - Network call
    func fetchFavoriteAds(continuationToken: String?) {
        self.repository?.adsRepository.fetchFavoriteAds(continustionTOken: continuationToken!, completion: { (adsResponse, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }

            if adsResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                self.error = nil
                self.isLoading = false
                self.favAds = adsResponse?.data
            }

        })
    }
}
