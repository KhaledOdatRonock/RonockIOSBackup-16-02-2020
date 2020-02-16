//
//  BaseTableViewController.swift
//  MVVM_Starter_Project
//
//  Created by Saferoad on 7/10/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import IHProgressHUD
import MaterialComponents.MaterialDialogs

class BaseTableViewController: UITableViewController {
    
    var ronockAssistant: RonockAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
//           let tabBarHeight = (tabBarController?.tabBar.frame.height ?? 0 ) + UIApplication.shared.keyWindow!.safeAreaInsets.bottom
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
    
    func reset() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "SplashVC")
    }
}
