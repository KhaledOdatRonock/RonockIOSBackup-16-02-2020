//
//  EditProfileViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 12/5/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class EditProfileViewModel {
    
    // MARK: - Properties
       private var profile: Profile? {
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
    var didFinishFetch: ((_ profile: Profile?) -> ())?
    var didProfileUpdated: (() -> ())?
    var didProfileImageUploaded: (() -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    func fetchProfile(){
        repository?.userManagmentRepository.fetchProfile(completion: { apiResponse, error  in
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
    func sendProfileData(profile: Profile){
        repository?.userManagmentRepository.updateUserProfile(profile: profile, completion: { apiResponse, error in
            if error != nil {
            self.error = error
            return
        }
        
        if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
            self.didProfileUpdated!()
        }else if apiResponse?.code == Enums.RequestResponse.FAILED.rawValue{
            self.error = NSError(domain:"", code:apiResponse?.code ?? -1, userInfo:["message":apiResponse?.message ?? ""])
        }
            
        })
}
    
    func uploadProfileImage(image: UIImage){
            repository?.userManagmentRepository.uploadProfileImage(image: image, completion: { apiResponse, error in
                if error != nil {
                self.error = error
                return
            }
            
            if apiResponse?.code == Enums.RequestResponse.SUCCESS.rawValue{
                self.didProfileImageUploaded!()
            }else if apiResponse?.code == Enums.RequestResponse.FAILED.rawValue{
                self.error = NSError(domain:"", code:apiResponse?.code ?? -1, userInfo:["message":apiResponse?.message ?? ""])
            }
                
            })
    }
}
