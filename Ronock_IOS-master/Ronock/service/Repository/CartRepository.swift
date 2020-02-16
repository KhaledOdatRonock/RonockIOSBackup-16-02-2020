//
//  CartRepository.swift
//  Ronock
//
//  Created by Khaled Odat on 11/20/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class CartRepository{
    
    let remoteRepo: DataService = DataService.shared
    let localRepo: LocalStorage = LocalStorage.shared
    
    static let shared = CartRepository();
    
    func fetchMyCart(completion: @escaping (WebAPIResponse<[CartHeader]>, Error?) -> ()) {
        remoteRepo.fetchMyCart(completion: completion)
    }
    
    func addCartToDB(clippedItem: ClippedItem, adverstiserID: String, adverstiserName: String, adverstiserLogo: String) {
        
        let jsonEncoder = JSONEncoder()
        do {
            
            let cart = Cart()
            cart.advertiserID = adverstiserID
            cart.advertiserLogo = adverstiserLogo
            cart.advertiserName = adverstiserName
            cart.sliceId = clippedItem.sliceId
            
            let jsonData = try jsonEncoder.encode(clippedItem)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            
            cart.clip = jsonString
            
            localRepo.addCart(cart: cart)
            print("Added Success")
        }
        catch {
            print(error)
        }
        
        
        
    }
    func fetchSliceDetails(sliceID: String, userID: String, completion: @escaping (SliceDetailsResponse?, Error?) -> ()) {
        remoteRepo.fetchSliceDetails(sliceID: sliceID, userID: userID, completion: completion)
    }
    
    func clipSlice(clipped: ClippedSliceParams, completion: @escaping (String?, Error?) -> ()) {
        
        let clippedItem = ClippedItem(advertisementId: clipped.advertisementID, advertisementExpiryDate: clipped.advertisementExpiryDate, sliceId: clipped.sliceID, sliceUrl: clipped.sliceURL)
        
        addCartToDB(clippedItem: clippedItem, adverstiserID: clipped.advertiserID, adverstiserName: clipped.advertiserName, adverstiserLogo: clipped.advertiserLogo)
        
        remoteRepo.clipSlice(clipped: clipped, completion: completion)
    }
    
    func unClipSlice(clipped: UnClipSliceParams, completion: @escaping (String?, Error?) -> ()) {
        remoteRepo.unClipSlice(clipped: clipped, completion: completion)
        localRepo.removeCart(sliceID: clipped.sliceID)
    }
    func getAnonymousCart(completion: @escaping ([CartHeader], Error?) -> ()) {
        do {
            var cartHeaders: [CartHeader] = []

            let carts = localRepo.fetchAllCarts()
            

            
            for cart in carts{
                
                let cartHeader = CartHeader(advertiserId: cart.advertiserID, advertiserName: cart.advertiserName, advertiserLogo: cart.advertiserLogo, clippedItem: [])

                let jsonData = cart.clip!.data(using: .utf8)!
                let jsonDecoder = JSONDecoder()
                let clip = try jsonDecoder.decode(ClippedItem.self, from: jsonData)
                
                if isInArray(objs: cartHeaders, advID: cart.advertiserID ?? ""){
                    for i in 0...cartHeaders.count - 1 {
                        if cartHeaders[i].advertiserId == cart.advertiserID{
                            cartHeaders[i].clippedItem?.append(clip)
                        }
                    }
                }else{
                     cartHeaders.append(cartHeader)
                }

               
            }
            
            if !cartHeaders.isEmpty {
                for i in 0...cartHeaders.count - 1{
                    if cartHeaders[i].clippedItem?.isEmpty ?? true {
                        cartHeaders.remove(at: i)
                    }
                }
            }
            
            
            completion(cartHeaders, nil)
        }
        catch {
            print(error)
        }
    }
    
    func removeCart(sliceId: String) {
        localRepo.removeCart(sliceID: sliceId)
    }
    
    func clearCart()  {
        localRepo.clearCart()
    }
    
    func isInArray(objs: [CartHeader], advID: String) -> Bool {
        for o in objs{
            if o.advertiserId == advID {
                return true
            }
        }
        return false
    }
    
    
}
