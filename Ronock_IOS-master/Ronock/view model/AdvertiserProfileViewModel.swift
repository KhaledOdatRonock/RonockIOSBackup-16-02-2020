//
//  AdvertiserProfileViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 12/8/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class AdvertiserProfileViewModel {
    // MARK: - Properties
      private var profile: AdvertiserProfile? {
          didSet {
              guard let p = profile else { return }
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
      var didFinishFetch: ((_ profile: AdvertiserProfile?) -> ())?
      
      // MARK: - Constructor
      init(repository: Repository) {
          self.repository = repository
      }
      
    func fetchProfile(advertiserID: String){
          repository?.adsRepository.fetchAdvertiserProfile(advertiserID: advertiserID, completion: { apiResponse, error  in
              if error != nil {
                  self.error = error
                  return
              }

              if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                  self.profile = apiResponse?.data
              }else if apiResponse?.code == Enums.RequestResponse.FAILED.rawValue{
                  self.error = NSError(domain:"", code:apiResponse?.code ?? -1, userInfo:["message":apiResponse?.message])
              }
          })
      }
}
