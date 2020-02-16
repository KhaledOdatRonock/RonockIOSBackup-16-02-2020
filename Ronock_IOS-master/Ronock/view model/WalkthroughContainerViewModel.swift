//
//  WalkthroughContainerViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 1/9/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class WalkthroughContainerViewModel {
    
    var walkthroughPages: [WalkthroughPage]?{
        didSet{
            self.didFinishFetch?(walkthroughPages!)
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
    var didFinishFetch: ((_ walkthroughPages: [WalkthroughPage]) -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
        func fetchWalkthroughPages(){
               
            repository?.userManagmentRepository.fetchWalkthroughPages(completion: { webApiResponse, error  in
                if error != nil {
                    self.error = error
                    return
                }
                if webApiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                    self.walkthroughPages = webApiResponse?.data
                   }
               })
           }
}
