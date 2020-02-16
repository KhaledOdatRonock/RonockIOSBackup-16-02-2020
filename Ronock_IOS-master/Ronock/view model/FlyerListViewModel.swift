//
//  FlyerListViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 11/17/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

class FlyerListViewModel{
    // MARK: - Properties
    private var flyersList: ListDataResponse<Flyer>? {
        didSet {
            guard let p = flyersList else { return }
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
    var didFinishFetch: ((_ flyers: ListDataResponse<Flyer>) -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: - Network call
    func fetchFlyers(continuationToken: String) {
        self.repository?.flyersRepository.fetchFlyers(continustionTOken: continuationToken, completion: { (flyersResponse, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            
            if flyersResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                self.error = nil
                self.isLoading = false
                self.flyersList = flyersResponse?.data
            }
            
        })
    }
}
