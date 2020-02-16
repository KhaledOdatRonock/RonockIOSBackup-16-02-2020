//
//  IntrestsViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 11/27/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class IntrestsViewModel {
    // MARK: - Properties
    private var intretsList: [Intrest]?{
        didSet {
            guard let p = intretsList else { return }
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
    var didFinishFetch: ((_ intrests: [Intrest]) -> ())?
    var didIntrestsReplaced: (() -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    
    // MARK: - Network call
    func fetchIntrests() {
        self.repository?.fetchIntrests(completion: { (apiResponse, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            
            if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                self.error = nil
                self.isLoading = false
                self.intretsList = apiResponse?.data
            }
            
        })
    }
    func replaceIntrests(intrests: [Int]) {
        self.repository?.userManagmentRepository.replaceUserIntrests(intrests: intrests, completion: { (apiResponse, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            
            if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                self.error = nil
                self.isLoading = false
                self.didIntrestsReplaced!()
            }
            
        })
    }
}
