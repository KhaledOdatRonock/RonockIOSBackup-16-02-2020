//
//  UserManagmentRepository.swift
//  Ronock
//
//  Created by Khaled Odat on 11/27/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class UserManagmentRepository {
    let remoteRepo: DataService = DataService.shared
    let localRepo: LocalStorage = LocalStorage.shared
    
    static let shared = UserManagmentRepository()
    
    func fetchProfile(completion: @escaping (WebAPIResponse<Profile>?, Error?) -> ()) {
        remoteRepo.fetchProfile(completion: completion)
    }
    
    func silentNewUser(completion: @escaping (WebAPIResponse<String>?, Error?) -> ()) {
        remoteRepo.silentNewUser(completion: completion)
    }
    
    func replaceUserIntrests(intrests: [Int], completion: @escaping (WebAPIResponse<String>?, Error?) -> ()) {
        remoteRepo.replaceIntrests(intrests: intrests, completion: completion)
    }
    
    func updateUserProfile(profile: Profile, completion: @escaping (WebAPIResponse<String>?, Error?) -> ()) {
        remoteRepo.updateUserProfile(profile: profile, completion: completion)
    }
    
    func uploadProfileImage(image: UIImage, completion: @escaping (WebAPIResponse<String>?, Error?) -> ()) {
        remoteRepo.uploadProfileImage(image: image, completion: completion)
    }
    
     func fetchWalkthroughPages(completion: @escaping (WebAPIResponse<[WalkthroughPage]>?, Error?) -> ()) {
         remoteRepo.fetchWalkthroughPages(completion: completion)
     }
}
