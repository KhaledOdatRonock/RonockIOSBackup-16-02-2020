//
//  HomePageViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 12/9/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

class HomePageViewModel {
    // MARK: - Properties
      private var adsList: [DealSection]? {
          didSet {
              guard let p = adsList else { return }
              self.didFinishFetch?(p)
          }
      }
    private var storyList: [Story]? {
        didSet {
            guard let p = storyList else { return }
            self.didFinishStories?(p)
        }
    }
    private var hotDealsList: [HomeAd]? {
           didSet {
               guard let p = hotDealsList else { return }
               self.didFinishHotDeals?(p)
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
      var didFinishFetch: ((_ adsSections: [DealSection]?) -> ())?
      var didFinishStories: ((_ stories: [Story]?) -> ())?
      var didFinishHotDeals: ((_ hotDeals: [HomeAd]?) -> ())?

      // MARK: - Constructor
      init(repository: Repository) {
          self.repository = repository
      }
      
    func fetchHomePageAds(){
          repository?.adsRepository.fetchHomePageAds(completion: { apiResponse, error  in
              if error != nil {
                  self.error = error
                  return
              }

              if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                  self.adsList = apiResponse?.data
              }else if apiResponse?.code == Enums.RequestResponse.FAILED.rawValue{
                  self.error = NSError(domain:"", code:apiResponse?.code ?? -1, userInfo:["message":apiResponse?.message])
              }
          })
      }
    
    func fetchStories(){
          repository?.adsRepository.fetchStories(completion: { apiResponse, error  in
              if error != nil {
                  self.error = error
                  return
              }

              if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                  self.storyList = apiResponse?.data
              }else if apiResponse?.code == Enums.RequestResponse.FAILED.rawValue{
                  self.error = NSError(domain:"", code:apiResponse?.code ?? -1, userInfo:["message":apiResponse?.message])
              }
          })
      }
    
    func fetchHotDeals(){
          repository?.adsRepository.fetchHotDeals(completion: { apiResponse, error  in
              if error != nil {
                  self.error = error
                  return
              }

              if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                  self.hotDealsList = apiResponse?.data
              }else if apiResponse?.code == Enums.RequestResponse.FAILED.rawValue{
                  self.error = NSError(domain:"", code:apiResponse?.code ?? -1, userInfo:["message":apiResponse?.message])
              }
          })
      }
    
}
