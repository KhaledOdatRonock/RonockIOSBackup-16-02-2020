//
//  RedeemCouponViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 12/25/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class RedeemCouponViewModel {
    
    var coupone: Coupon?{
        didSet{
            self.didFinishFetch?(coupone!)
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
    var didFinishFetch: ((_ coupon: Coupon) -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    func fetchCouponeDetails(){
           
//        repository?.notificationsRepository.fetchMyNotifications(continustionTOken: continustionTOken, completion: { webApiResponse, error  in
//            if error != nil {
//                self.error = error
//                return
//            }
//            if webApiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
//                self.notificationList = webApiResponse?.data
//               }
//           })
       }
}
