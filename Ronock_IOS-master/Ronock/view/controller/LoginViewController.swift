//
//  LoginViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 10/13/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import MSAL
import AppCenterAnalytics
import AppCenterCrashes
import Lottie

class LoginViewController: BaseViewController {
    
    var accessToken: String?
    let viewModel = LoginViewModel(repository: Repository.shared)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        androidWave.loopMode = .loop
//        
//        Animation.loadedFrom(url: URL(string: "https://raw.githubusercontent.com/airbnb/lottie-android/master/LottieSample/src/main/assets/AndroidWave.json")!, closure: {animation in
//            self.androidWave.animation = animation
//            self.androidWave.play()
//        }, animationCache: LRUAnimationCache.sharedCache)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "LoginViewController"])
    }
    
    
    @IBAction func loginNow(_ sender: Any) {
        do{
            let authority = try getAuthority(forPolicy: Constants.B2cConfiguration.SISU_POLICY)
            
            let webViewParameters = MSALWebviewParameters(parentViewController: self)
            let parameters = MSALInteractiveTokenParameters(scopes: Constants.B2cConfiguration.SCOPES, webviewParameters: webViewParameters)
            parameters.promptType = .selectAccount
            parameters.authority = authority
            self.msalApplication.acquireToken(with: parameters) { (result, error) in
                
                guard let result = result else {
                    
                    print("Could not acquire token: \(error ?? "No error informarion" as! Error)")
                    MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_TRACE, withProperties: ["loginError": "Could not acquire token: \(error ?? "No error informarion" as! Error)"])
                    return
                }
                self.accessToken = result.accessToken
                self.viewModel.didFinishAuthenticat = {
                    //TODO: replace the current navigationController with the main nav controller
                    MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_TRACE, withProperties: ["loginSuccess": "\(result.idToken ?? "") success logged in"])
                    self.performSegue(withIdentifier: Constants.SegueIDs.LOGIN_TO_INTRESTS_SEGUE, sender: self)
                }
                
                self.viewModel.authenticatedSuccess(accessToken: result.idToken ?? "")
                
            }
        } catch {
            print("Unable to create authority \(error)")
            MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_TRACE, withProperties: ["loginError": "Unable to create authority : \(error)"])
        }
        
    }

}
