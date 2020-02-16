//
//  AdsListViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 11/5/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class AdsListViewModel{
    // MARK: - Properties
    private var adsNearest: [Ad]? {
        didSet {
            guard let p = adsNearest else { return }
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
    var didFinishFetch: ((_ ads: [Ad]) -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: - Network call
    func fetchMapListAds() {
        self.repository?.adsRepository.fetchMapListAds(completion: { (ads, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.adsNearest = ads
        })
    }
}
