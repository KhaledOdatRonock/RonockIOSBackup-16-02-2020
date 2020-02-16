//
//  MapViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 10/30/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import UIKit

class MapViewModel{
    // MARK: - Properties
    private var adsNearest: [MapLocation]? {
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
    //    var imageLoadedSuccess: ((UIImage?) -> ())?
    var didFinishFetch: ((_ ads: [MapLocation]) -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: - Network call
    func fetchMapAds() {
        self.repository?.adsRepository.fetchMapLocationsAds(completion: { (mapLocations, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.adsNearest = mapLocations?.data
        })
    }
    
    func getImageFromURL(url: String, completion: @escaping (UIImage?) -> ()) {
//        self.repository?.getImageFromURL(url: NSURL(string: url)! as URL, completion: {image, error in
//            completion(image)
//        })
    }
    
    
}
