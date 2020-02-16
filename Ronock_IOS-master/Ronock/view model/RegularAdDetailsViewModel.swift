//
//  RegularAdDetailsViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 12/17/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class RegularAdDetailsViewModel {
    // MARK: - Properties
         private var ad: RegularAdDetails? {
             didSet {
                 guard let p = ad else { return }
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
         var didFinishFetch: ((_ ad: RegularAdDetails) -> ())?
         
         // MARK: - Constructor
         init(repository: Repository) {
             self.repository = repository
         }
         
         // MARK: - Network call
         func fetchRegularAdDetails() {
             self.repository?.adsRepository.fetchRegularAdDetails(completion: { (apiResponse, error) in
                 if let error = error {
                     self.error = error
                     self.isLoading = false
                     return
                 }

                 if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                     self.error = nil
                     self.isLoading = false
                     self.ad = apiResponse?.data
                 }

             })
         }
}
