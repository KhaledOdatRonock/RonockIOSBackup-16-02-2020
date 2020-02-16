//
//  BaseViewController.swift
//  MVVM Alamofire
//
//  Created by Saferoad on 7/10/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import IHProgressHUD
import MaterialComponents.MaterialDialogs
import MSAL
import JWTDecode

class BaseViewController: UIViewController {
    
    var msalApplication: MSALPublicClientApplication!
    var ronockAssistant: RonockAssistant?
    var currentAccount: MSALAccount?
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let userManagmentStoryboard = UIStoryboard(name: "UserManagment", bundle: nil)
    let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        initMSALApllication()
        
    }
    
    func initMSALApllication(){
        do {
            let authority = try self.getAuthority(forPolicy: Constants.B2cConfiguration.SISU_POLICY)
            
            // Provide configuration for MSALPublicClientApplication
            // MSAL will use default redirect uri when you provide nil
            let pcaConfig = MSALPublicClientApplicationConfig(clientId: Constants.B2cConfiguration.CLIENT_ID, redirectUri: nil, authority: authority)
            self.msalApplication = try MSALPublicClientApplication(configuration: pcaConfig)
            msalApplication.validateAuthority = false
        } catch {
            print("Unable to create application \(error)")
        }
    }
    
    func checkTokenExpiration() {
        
        do {
            let jwt = try decode(jwt: UserDefaults.standard.string(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN) ?? "")
            
            let expirationDate = jwt.expiresAt ?? nil

            if expirationDate! > Date() {
                print("Access Token is not expired")
            }else{
                refreshToken()
                print("Access token is expired")
            }
            
        } catch {
            print("Cannot decode the access token")
        }
    }
    
    func refreshToken() {
        do {
               
            let authority = try self.getAuthority(forPolicy: Constants.B2cConfiguration.SISU_POLICY)
                  
                  guard let thisAccount = try self.getAccountByPolicy(withAccounts: msalApplication.allAccounts(), policy: Constants.B2cConfiguration.SISU_POLICY) else {
                      print("There is no account available!")
                      return
                  }
                  
            let parameters = MSALSilentTokenParameters(scopes: Constants.B2cConfiguration.SCOPES, account:thisAccount)
                  parameters.authority = authority
                  self.msalApplication.acquireTokenSilent(with: parameters) { (result, error) in
                      guard let result = result else {
                          return
                      }
                      let accessToken = result.accessToken
                    UserDefaults.standard.set(accessToken, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN)
                  }
              } catch {
                  print("Unable to construct parameters before calling acquire token \(error)")
              }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkTokenExpiration()
        ronockAssistant = RonockAssistant(view: self.view, tabBarHeight: (tabBarController?.tabBar.frame.height ?? 0 ))
        ronockAssistant?.setupRonockAssistant(width: 100, height: 100)
    }
    // MARK: - UI Setup
    func activityIndicatorStart() {
        IHProgressHUD.show()
    }
    func activityIndicatorStop() {
        IHProgressHUD.dismiss()
    }
    
    public func showAlert(title: String, msg: String, okHandler: @escaping ()->()){
        let alertController = MDCAlertController(title: title, message: msg)
        let action = MDCAlertAction(title:"OK") { (action) in okHandler() }
        alertController.addAction(action)
        
        present(alertController, animated:true, completion:nil)
    }
    
    func switchToViewController(identifier: String) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) else { return }
        self.navigationController?.setViewControllers([viewController], animated: false)
        
    }
    
    func reset() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "SplashVC")
    }
    
    func getAuthority(forPolicy policy: String) throws -> MSALB2CAuthority {
        guard let authorityURL = URL(string: String(format: Constants.B2cConfiguration.ENDPOINT_URL, Constants.B2cConfiguration.TENANT, policy)) else {
            throw NSError(domain: "SomeDomain",
                          code: 1,
                          userInfo: ["errorDescription": "Unable to create authority URL!"])
        }
        return try MSALB2CAuthority(url: authorityURL)
    }
    
    func getAccountByPolicy (withAccounts accounts: [MSALAccount], policy: String) throws -> MSALAccount? {
          
          for account in accounts {
              // This is a single account sample, so we only check the suffic part of the object id,
              // where object id is in the form of <object id>-<policy>.
              // For multi-account apps, the whole object id needs to be checked.
              if let homeAccountId = account.homeAccountId, let objectId = homeAccountId.objectId {
                  if objectId.hasSuffix(policy.lowercased()) {
                      return account
                  }
              }
          }
          return nil
      }
}
