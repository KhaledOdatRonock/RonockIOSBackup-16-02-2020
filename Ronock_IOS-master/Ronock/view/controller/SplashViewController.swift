//
//  SplashViewController.swift
//  MVVM Alamofire
//
//  Created by Saferoad on 7/10/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let sessionID = UserDefaults.standard.string(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_SESSION_ID)
        
        if  sessionID == nil {
            let generatedSessionID = UUID().description
            UserDefaults.standard.set(generatedSessionID, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_SESSION_ID)
        }
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            
            let isNotFirstTime = UserDefaults.standard.bool(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_NOT_FIRST_TIME)
            
            if !isNotFirstTime {
                self.performSegue(withIdentifier: Constants.SegueIDs.SPLAS_TO_LOGIN_SEGUE, sender: self)
            }else{
                self.performSegue(withIdentifier: Constants.SegueIDs.SPLAS_TO_MAIN_SEGUE, sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        navigationController?.navigationBar.isHidden = false
    }
    
    
}
