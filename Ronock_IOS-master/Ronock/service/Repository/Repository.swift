//
//  Repository.swift
//  MVVM_Starter_Project
//
//  Created by Saferoad on 7/11/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import UIKit

class Repository {
    
    static let shared = Repository()
    let remoteRepo: DataService = DataService.shared
    let localRepo: LocalStorage = LocalStorage.shared
    
    let cartRepository = CartRepository.shared
    let flyersRepository = FlyersRepository.shared
    let adsRepository = AdsRepository.shared
    let userManagmentRepository = UserManagmentRepository.shared
    let notificationsRepository = NotificationsRepository.shared
    
    func fetchSuccess(completion: @escaping (WebAPIResponse<[Catalog]>, Error?) -> ()) {
        remoteRepo.fetchSuccess(completion: completion)
    }
    
    func fetchFailed(completion: @escaping (WebAPIResponse<[Catalog]>, Error?) -> ()) {
        remoteRepo.fetchFailed(completion: completion)
    }
    
    func fetchDone(completion: @escaping (WebAPIResponse<[Ad]>, Error?) -> ()) {
        remoteRepo.fetchDone(completion: completion)
    }
    
    func fetchUnAuthorized(completion: @escaping (WebAPIResponse<[Catalog]>, Error?) -> ()) {
        remoteRepo.fetchUnAuthorized(completion: completion)
    }
    
    func fetchForceUpadte(completion: @escaping (WebAPIResponse<[Catalog]>, Error?) -> ()) {
        remoteRepo.fetchForceUpdate(completion: completion)
    }
    
    
    func getImageFromURL(url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        remoteRepo.getImageFromURL(url: url, completion: completion)
    }
    
    func fetchIntrests(completion: @escaping (WebAPIResponse<[Intrest]>?, Error?) -> ()) {
        remoteRepo.fetchIntrests(completion: completion)
    }
    
    func searchBrands(continustionTOken: String, filterText: String, completion: @escaping (WebAPIResponse<ListDataResponse<Brand>>?, Error?) -> ()) {
        remoteRepo.searchBrands(continustionTOken: continustionTOken,filterText: filterText, completion: completion)
    }
    
    func addRecentSearch(recentSearch: RecentSearch) {
         
         localRepo.addRecentSearch(recentSearch: recentSearch)
         print("Added Success")
     }
    
    func fetchAllRecentSearches(completion: @escaping ([RecentSearch], Error?) -> ()) {
        let recents = localRepo.fetchAllRecentSearches()
        completion(recents, nil)
    }
}
