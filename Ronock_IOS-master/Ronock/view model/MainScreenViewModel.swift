//
//  MainScreenViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 10/15/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class MainScreenViewModel{
    // MARK: - Properties
    //    private var ToDoList: [TodoResponse]? {
    //        didSet {
    //            guard let p = ToDoList else { return }
    //            self.didFinishFetch?(p)
    //        }
    //    }
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
    var didFinishFetch: ((_ todos: [Any]) -> ())?
    
    var didFinishSuccess: ((_ catalogs: [Catalog]) -> ())?
    var didFinishFailed: ((_ errors: [MyError]) -> ())?
    var didFinishDone: ((_ message: String) -> ())?
    var didFinishUnAuthorized: ((_ message: String) -> ())?
    var didFinishForceUpdate: ((_ errorMessage: String) -> ())?
    
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    func fetchSuccess(){
        
        repository?.fetchSuccess(completion: { webApiResponse, error  in
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue && webApiResponse.message == "Done"{
                self.didFinishDone!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                self.didFinishSuccess!(webApiResponse.data ?? [])
            }else if webApiResponse.code == Enums.RequestResponse.FAILED.rawValue {
                self.didFinishFailed!(webApiResponse.errors)
            }else if webApiResponse.code == Enums.RequestResponse.UNAUTHORIZED.rawValue {
                self.didFinishUnAuthorized!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.FORCE_UPDATE.rawValue {
                self.didFinishForceUpdate!(webApiResponse.errors[0].value)
            }
        })
    }
    
    func fetchDone(){
        
        repository?.fetchDone(completion: { webApiResponse, error  in
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue && webApiResponse.message == "Done"{
                self.didFinishDone!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                //                self.did!(webApiResponse.data)
            }else if webApiResponse.code == Enums.RequestResponse.FAILED.rawValue {
                self.didFinishFailed!(webApiResponse.errors)
            }else if webApiResponse.code == Enums.RequestResponse.UNAUTHORIZED.rawValue {
                self.didFinishUnAuthorized!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.FORCE_UPDATE.rawValue {
                self.didFinishForceUpdate!(webApiResponse.errors[0].value)
            }
        })
    }
    
    func fetchFailed(){
        
        repository?.fetchFailed(completion: { webApiResponse, error  in
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue && webApiResponse.message == "Done"{
                self.didFinishDone!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                self.didFinishSuccess!(webApiResponse.data ?? [])
            }else if webApiResponse.code == Enums.RequestResponse.FAILED.rawValue {
                self.didFinishFailed!(webApiResponse.errors)
            }else if webApiResponse.code == Enums.RequestResponse.UNAUTHORIZED.rawValue {
                self.didFinishUnAuthorized!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.FORCE_UPDATE.rawValue {
                self.didFinishForceUpdate!(webApiResponse.errors[0].value)
            }
        })
    }
    
    func fetchUnAuthorized(){
        
        repository?.fetchUnAuthorized(completion: { webApiResponse, error  in
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue && webApiResponse.message == "Done"{
                self.didFinishDone!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                self.didFinishSuccess!(webApiResponse.data ?? [])
            }else if webApiResponse.code == Enums.RequestResponse.FAILED.rawValue {
                self.didFinishFailed!(webApiResponse.errors)
            }else if webApiResponse.code == Enums.RequestResponse.UNAUTHORIZED.rawValue {
                self.didFinishUnAuthorized!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.FORCE_UPDATE.rawValue {
                self.didFinishForceUpdate!(webApiResponse.errors[0].value)
            }
        })
    }
    
    func fetchForceUpdate(){
        
        repository?.fetchForceUpadte(completion: { webApiResponse, error  in
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue && webApiResponse.message == "Done"{
                self.didFinishDone!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                self.didFinishSuccess!(webApiResponse.data ?? [])
            }else if webApiResponse.code == Enums.RequestResponse.FAILED.rawValue {
                self.didFinishFailed!(webApiResponse.errors)
            }else if webApiResponse.code == Enums.RequestResponse.UNAUTHORIZED.rawValue {
                self.didFinishUnAuthorized!(webApiResponse.message)
            }else if webApiResponse.code == Enums.RequestResponse.FORCE_UPDATE.rawValue {
                self.didFinishForceUpdate!(webApiResponse.errors[0].value)
            }
        })
    }
}
