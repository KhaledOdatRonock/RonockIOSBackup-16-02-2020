//
//  LocalStorage.swift
//  MVVM_Starter_Project
//
//  Created by Saferoad on 7/11/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import RealmSwift

class LocalStorage{
    
    lazy var realm = try! Realm()
    
    static let shared = LocalStorage()
    
    
    public func addUserToDB(user: User){
        do{
            try realm.write{
                realm.add(user)
            }
            
        }catch
        {
            print(error.localizedDescription)
        }
    }
    
    public func fetchAllUsers() -> [User]{
        return realm.objects(User.self).dropLast()
    }
    
    
    public func addCart(cart: Cart){
       do{
            try realm.write{
                realm.add(cart, update: Realm.UpdatePolicy.modified)
            }
            
        }catch
        {
            print(error.localizedDescription)
        }
    }
    
    
    public func fetchAllCarts() -> [Cart]{
        return Array(realm.objects(Cart.self))
    }
    func removeCart(sliceID: String) {
        do{
            let cartItem = realm.objects(Cart.self).filter("sliceId = '\(sliceID)'")

            try realm.write{
                realm.delete(cartItem)
            }
            
        }catch
        {
            print(error.localizedDescription)
        }
    }
    
    func clearCart() {
        do{
            let cartItems = realm.objects(Cart.self)

            try realm.write{
                realm.delete(cartItems)
            }
            
        }catch
        {
            print(error.localizedDescription)
        }
    }
    
    
    public func addRecentSearch(recentSearch: RecentSearch){
        let currentSearch = recentSearch
        currentSearch.id = realm.objects(RecentSearch.self).count + 1
        
       do{
            try realm.write{
                realm.add(recentSearch, update: Realm.UpdatePolicy.modified)
            }
            
        }catch
        {
            print(error.localizedDescription)
        }
    }
    
    public func fetchAllRecentSearches() -> [RecentSearch]{
        if realm.objects(RecentSearch.self).count > 10 {
            return Array(realm.objects(RecentSearch.self).sorted(byKeyPath: "id", ascending: false)[0...9])
        }
        return Array(realm.objects(RecentSearch.self).sorted(byKeyPath: "id", ascending: false))
       }
}
