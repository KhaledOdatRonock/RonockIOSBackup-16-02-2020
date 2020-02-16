//
//  AdsRepository.swift
//  Ronock
//
//  Created by Khaled Odat on 11/20/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class AdsRepository{
    let remoteRepo: DataService = DataService.shared
    let localRepo: LocalStorage = LocalStorage.shared
    
    static let shared = AdsRepository()
    
    
    func fetchMapListAds(completion: @escaping ([Ad]?, Error?) -> ()) {
        remoteRepo.fetchMapListAds(completion: completion)
    }
    
    func fetchMapLocationsAds(completion: @escaping (WebAPIResponse<[MapLocation]>?, Error?) -> ()) {
        remoteRepo.fetchMapLocationsAds(completion: completion)
    }
    
    func fetchAdvertiserProfile(advertiserID: String, completion: @escaping (WebAPIResponse<AdvertiserProfile>?, Error?) -> ()) {
        remoteRepo.fetchAdvertiserPRofile(advertiserID: advertiserID, completion: completion)
    }
    
    func fetchHomePageAds(completion: @escaping (WebAPIResponse<[DealSection]>?, Error?) -> ()) {
        remoteRepo.fetchHomePageAds(completion: completion)
    }
    func fetchAdsByCategory(continustionTOken: String, completion: @escaping (WebAPIResponse<ListDataResponse<HomeAd>>?, Error?) -> ()) {
        remoteRepo.fetchAdsByCategory(continustionTOken: continustionTOken, completion: completion)
    }
    
    func fetchVideoAdDetails(completion: @escaping (WebAPIResponse<VideoAdDetails>?, Error?) -> ()) {
        remoteRepo.fetchVideoAdDetails(completion: completion)
    }
    
    func fetchRegularAdDetails(completion: @escaping (WebAPIResponse<RegularAdDetails>?, Error?) -> ()) {
        remoteRepo.fetchRegularAdDetails(completion: completion)
    }
    
    func fetchMyCoupons(completion: @escaping (WebAPIResponse<ListDataResponse<Coupon>>?, Error?) -> ()) {
        remoteRepo.fetchMyCoupons(completion: completion)
    }
    
    func fetchCouponDetails(completion: @escaping (WebAPIResponse<CouponDetails>?, Error?) -> ()) {
        remoteRepo.fetchCouponDetails(completion: completion)
    }
    
    func fetchStories(completion: @escaping (WebAPIResponse<[Story]>?, Error?) -> ()) {
        remoteRepo.fetchStories(completion: completion)
    }
    
    func fetchHotDeals(completion: @escaping (WebAPIResponse<[HomeAd]>?, Error?) -> ()) {
        remoteRepo.fetchHotDeals(completion: completion)
    }
    
    func fetchFavoriteAds(continustionTOken: String, completion: @escaping (WebAPIResponse<ListDataResponse<FavoriteAd>>?, Error?) -> ()) {
        remoteRepo.fetchFavoriteAds(continustionTOken: continustionTOken, completion: completion)
    }
}
