//
//  CartViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 11/14/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class CartViewModel{
    // MARK: - Properties
    private var cartHeaders: [CartHeader]? {
        didSet {
            guard let p = cartHeaders else { return }
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
    var didFinishFetch: ((_ cartHeaders: [CartHeader]) -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: - Network call
    func fetchMyCart() {
        if UserDefaults.standard.bool(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_LOGGED_IN)
        {
            self.repository?.cartRepository.fetchMyCart(completion: { (cartHeaders, error) in
                if let error = error {
                    self.error = error
                    self.isLoading = false
                    return
                }
                self.error = nil
                self.isLoading = false
                self.cartHeaders = cartHeaders.data
            })
        }else{
            self.repository?.cartRepository.getAnonymousCart(completion: { carts, error in
                self.cartHeaders = carts
            })
        }


    }
    
    func remoceCart(sliceId: String) {
        repository?.cartRepository.removeCart(sliceId: sliceId)
    }
}
