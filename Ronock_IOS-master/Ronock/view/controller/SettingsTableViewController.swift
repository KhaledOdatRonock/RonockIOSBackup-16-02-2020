//
//  SettingsTableViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/10/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import SelectionDialog
import PMAlertController
import AppCenterAnalytics
import AppCenterCrashes
import MOLH


class SettingsTableViewController: BaseTableViewController {
    
    @IBOutlet weak var allowNotificationSwitch: UISwitch!
    @IBOutlet weak var showRonockStartup: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRonockStartup.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        showRonockStartup.isOn = UserDefaults.standard.bool(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_RONOCK_ASSISTANT_STARTUP)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            //General Settings
            switch indexPath.row {
            case 0:
                //Language Preference
                let dialog = SelectionDialog(title: "Chose Language", closeButtonTitle: "Cancel")
                
                dialog.addItem(item: "English",
                               didTapHandler: { () in
                                dialog.close()
                                
                                MOLH.setLanguageTo("en")
                                MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_LANGUAGE_CHANGED: MOLHLanguage.currentAppleLanguage()])
                                
                                MOLH.reset(transition: .transitionCrossDissolve)
                                self.reset()
                                
                })
                
                
                dialog.addItem(item: "العربية",
                               didTapHandler: { () in
                                dialog.close()
                                MOLH.setLanguageTo("ar-001")
                                MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_LANGUAGE_CHANGED: MOLHLanguage.currentAppleLanguage()])
                                
                                MOLH.reset(transition: .transitionCrossDissolve)
                                self.reset()
                })
                
                dialog.show()
                
                break
            case 1:
                //Country Preference
                break
            case 2:
                //Logout
                self.doLogout()
                break
            default:
                break
            }
        }else if indexPath.section == 1{
            //Notifications Settings
            switch indexPath.row {
            case 0:
                //Allow PNs Preference
                print(allowNotificationSwitch.isOn)
                break
            case 1:
                //Notification Frequency Preference
                break
            case 2:
                //Notifications Blocklist Preference
                break
            case 3:
                //Notifications Preference
                break
                
            default:
                break
            }
        }else if indexPath.section == 2{
            //Ronock Assistant Settings
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        UserDefaults.standard.set(value, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_RONOCK_ASSISTANT_STARTUP)
        
        if value {
            self.ronockAssistant?.setupRonockAssistant(width: 100, height: 100)
        }else{
            self.ronockAssistant?.hideRonock()
        }
    }
    
    func doLogout()  {
        let mystoryboard = UIStoryboard(name: "UserManagment", bundle: nil)
        
        if UserDefaults.standard.bool(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_LOGGED_IN) {
               let alertVC = PMAlertController(title: "Logout!", description: "Do you want to logout?", image: #imageLiteral(resourceName: "dialog_header"), style: .alert)

               alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                   print("Capture action Cancel")
               }))

               alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in

                   MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_TRACE, withProperties: ["logoutSuccess": "\(UserDefaults.standard.string(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN) ?? "") success logged out"])

                   UserDefaults.standard.set(false, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_LOGGED_IN)
                   UserDefaults.standard.set("", forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN)
                        let viewController = mystoryboard.instantiateViewController(withIdentifier: "SplashVC")
                self.navigationController?.setViewControllers([viewController], animated: true)

               }))

               self.present(alertVC, animated: true, completion: nil)
           }else{
        
                let viewController = mystoryboard.instantiateViewController(withIdentifier: "WalkthroughContainerViewController")
        self.navigationController?.setViewControllers([viewController], animated: true)
           }
    }
}
