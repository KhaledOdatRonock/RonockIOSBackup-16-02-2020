//
//  MyCouponsViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 12/18/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class MyCouponsViewModel{
    // MARK: - Properties
       private var couponList: ListDataResponse<Coupon>? {
           didSet {
               guard let p = couponList else { return }
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
       var didFinishFetch: ((_ ads: ListDataResponse<Coupon>) -> ())?
       
       // MARK: - Constructor
       init(repository: Repository) {
           self.repository = repository
       }
       
       // MARK: - Network call
       func fetchMyCoupons() {
           self.repository?.adsRepository.fetchMyCoupons(completion: { (adsResponse, error) in
               if let error = error {
                   self.error = error
                   self.isLoading = false
                   return
               }

               if adsResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                   self.error = nil
                   self.isLoading = false
                   self.couponList = adsResponse?.data
               }

           })
       }
}
