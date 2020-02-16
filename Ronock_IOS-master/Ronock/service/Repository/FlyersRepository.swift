//
//  FlyersRepository.swift
//  Ronock
//
//  Created by Khaled Odat on 11/20/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class FlyersRepository{
    
    let remoteRepo: DataService = DataService.shared
    let localRepo: LocalStorage = LocalStorage.shared
    
    static let shared = FlyersRepository()
    
    func fetchFlyers(continustionTOken: String, completion: @escaping (WebAPIResponse<ListDataResponse<Flyer>>?, Error?) -> ()) {
        remoteRepo.fetchFlyers(continustionTOken: continustionTOken, completion: completion)
    }
}
