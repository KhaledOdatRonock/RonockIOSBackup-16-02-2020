//
//  LoginViewModel.swift
//  Ronock
//
//  Created by Khaled Odat on 10/14/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import JWTDecode

class LoginViewModel{
    // MARK: - Properties
    
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
    var didFinishAuthenticat: (() -> ())?
    
    // MARK: - Constructor
    init(repository: Repository) {
        self.repository = repository
    }
    
    
    func authenticatedSuccess(accessToken: String){
        
        do {
            let jwt = try decode(jwt: accessToken)
            
            let displayName = jwt.displayName
            let city = jwt.city
            let name = jwt.name
            let jobTitle = jwt.jobTitle
            let familyName = jwt.familyName
            let isNewUser  = jwt.newUser
            
            //TODO: get claims from access token and save them to UserDefaults
            
            UserDefaults.standard.set(displayName, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_DISPLAY_NAME)
            UserDefaults.standard.set(city, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_CITY)
            UserDefaults.standard.set(name, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_DISPLAY_NAME)
            UserDefaults.standard.set(jobTitle, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_JOB_TITLE)
            UserDefaults.standard.set(familyName, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_FAMILY)
            UserDefaults.standard.set(true, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_LOGGED_IN)
            UserDefaults.standard.set(accessToken, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN)
            UserDefaults.standard.set(true, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_NOT_FIRST_TIME)
            
            repository?.cartRepository.clearCart()
            
            if isNewUser ?? false {
                //TODO: call silent api to save this user, then push the walkthrough viewcontroller
                repository?.userManagmentRepository.silentNewUser(completion: { response, error in
                    print(response)
                })
                print("This is new User")
            }else{
                //TODO: Here go as usual without silent call and go to main page
                print("This is not new user (returned user)")
            }
            self.didFinishAuthenticat?()
            
        } catch {
            print("Cannot decode the access token")
        }
        
    }
}


extension JWT {
    var displayName: String? {
        return claim(name: "given_name").string
    }
    
    var name: String? {
        return claim(name: "name").string
    }
    
    var city: String? {
        return claim(name: "city").string
    }
    
    var jobTitle: String? {
        return claim(name: "jobTitle").string
    }
    
    var familyName: String? {
        return claim(name: "family_name").string
    }
    var newUser: Bool? {
        return claim(name: "newUser").rawValue as? Bool
    }
}
