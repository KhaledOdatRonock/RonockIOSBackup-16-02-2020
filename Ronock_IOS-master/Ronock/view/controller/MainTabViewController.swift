//
//  MainTabViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/10/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PMAlertController
import AppCenterAnalytics
import AppCenterCrashes
import MOLH
import SwiftRater

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftRater.check()
        
        viewControllers?.insert(AdsListViewController(), at: 2)

        tabBar.items?[2].isEnabled = false
        
        (tabBar as! CustomizedTabBar).didSearchClicked = {
            self.performSegue(withIdentifier: Constants.SegueIDs.MAINTAB_TO_SEARCH_SEGUE, sender: self)
        }
    }
    
    func reset() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "SplashVC")
    }
    
    func switchToViewController(identifier: String) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        
    }
    
}
