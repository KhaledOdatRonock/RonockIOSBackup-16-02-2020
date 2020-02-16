//
//  RonockAssistantDetailsVeiwModel.swift
//  Ronock
//
//  Created by Khaled Odat on 12/2/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class RonockAssistantDetailsVeiwModel {
    // MARK: - Properties
//       private var intretsList: [Intrest]?{
//           didSet {
//               guard let p = intretsList else { return }
//               self.didFinishFetch?(p)
//           }
//       }
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
       var didFinishFetch: ((_ intrests: [Intrest]) -> ())?
       
       // MARK: - Constructor
       init(repository: Repository) {
           self.repository = repository
       }
       
       
       // MARK: - Network call
       func fetchIntrests() {
//           self.repository?.fetchIntrests(completion: { (apiResponse, error) in
//               if let error = error {
//                   self.error = error
//                   self.isLoading = false
//                   return
//               }
//               
//               if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
//                   self.error = nil
//                   self.isLoading = false
//                   self.intretsList = apiResponse?.data
//               }
//               
//           })
       }
}
