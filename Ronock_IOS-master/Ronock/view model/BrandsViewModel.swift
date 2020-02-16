//
//  BrandsViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 1/19/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class BrandsViewModel {
    // MARK: - Properties
    private var brandList: ListDataResponse<Brand>?{
        didSet {
            guard let p = brandList else { return }
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
    var didFinishFetch: ((_ brands: ListDataResponse<Brand>?) -> ())?
    var didIntrestsReplaced: (() -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    
    // MARK: - Network call
    func fetchBrands(continuationToken: String, filterText: String) {
        self.repository?.searchBrands(continustionTOken: continuationToken, filterText: filterText, completion: { (apiResponse, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }

            if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                self.error = nil
                self.isLoading = false
                self.brandList = apiResponse?.data
            }

        })
    }
    func replaceBrands(intrests: [Int]) {
//        self.repository?.userManagmentRepository.replaceUserIntrests(intrests: intrests, completion: { (apiResponse, error) in
//            if let error = error {
//                self.error = error
//                self.isLoading = false
//                return
//            }
//
//            if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
//                self.error = nil
//                self.isLoading = false
//                self.didIntrestsReplaced!()
//            }
//
//        })
    }
}
