//
//  MainScreenViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 10/15/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PMAlertController
import AppCenterAnalytics
import AppCenterCrashes
import SelectionDialog
import MOLH
import SwiftyGif

class MainScreenViewController: BaseViewController {
    
    let viewModel = MainScreenViewModel(repository: Repository.shared)
    var imageview: UIImageView?
    var panGesture = UIPanGestureRecognizer()
    var selectedGIFImage = "animations/ronock_anim.gif"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error.localizedDescription)
            }
        }
        
        viewModel.didFinishFetch = { todos in
            
        }
        
        viewModel.didFinishSuccess = { catalogs in
            let alertVC = PMAlertController(title: "Success", description: "Items retreived : \(catalogs.count)", image: #imageLiteral(resourceName: "dialog_header"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                print("Capture action Cancel")
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
        
        viewModel.didFinishDone = { message in
            let alertVC = PMAlertController(title: "Done Message", description: message, image: #imageLiteral(resourceName: "dialog_header"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                print("Capture action Cancel")
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
        
        
        viewModel.didFinishFailed = { errors in
            let dialog = SelectionDialog(title: "List of Errors", closeButtonTitle: "Close")
            
            for err in errors {
                dialog.addItem(item: err.value,
                               icon:  #imageLiteral(resourceName: "ronock_logo"))
            }
            
            dialog.show()
            
        }
        
        viewModel.didFinishUnAuthorized = { message in
            let alertVC = PMAlertController(title: "Unautohrized", description: "Please signin first to procced this action", image: #imageLiteral(resourceName: "dialog_header"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                print("Capture action Cancel")
            }))
            alertVC.addAction(PMAlertAction(title: "Login", style: .cancel, action: { () -> Void in
                self.switchToViewController(identifier: "LoginViewController");
                
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
        
        viewModel.didFinishForceUpdate = { message in
            let alertVC = PMAlertController(title: "App Outdated", description: "Please update app from App Store to procced this action", image: #imageLiteral(resourceName: "dialog_header"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                print("Capture action Cancel")
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupRonockAssistant1(width: 100, height: 100)

        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "MainScreenViewController"])
    }
    
    @IBAction func profileCLicked(_ sender: Any) {
    }
    @IBAction func logoutClicked(_ sender: Any) {
        if !UserDefaults.standard.bool(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_LOGGED_IN) {
            let alertVC = PMAlertController(title: "Logout!", description: "Do you want to logout?", image: #imageLiteral(resourceName: "dialog_header"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                print("Capture action Cancel")
            }))
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                
                MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_TRACE, withProperties: ["logoutSuccess": "\(UserDefaults.standard.string(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN) ?? "") success logged out"])
                
                UserDefaults.standard.set(false, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_LOGGED_IN)
                UserDefaults.standard.set("", forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN)
                self.switchToViewController(identifier: "SplashVC")
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }else{
            self.switchToViewController(identifier: "SplashVC")
        }
        
        
        
    }
    
    @IBAction func showListOfScenariosClecked(_ sender: Any) {
        let dialog = SelectionDialog(title: "Chose Response", closeButtonTitle: "Close")
        
        dialog.addItem(item: "Success",
                       icon:  #imageLiteral(resourceName: "ronock_logo"),
                       didTapHandler: { () in
                        self.viewModel.fetchSuccess()
                        dialog.close()
        })
        
        
        dialog.addItem(item: "Done",
                       icon:  #imageLiteral(resourceName: "ronock_logo"),
                       didTapHandler: { () in
                        self.viewModel.fetchDone()
                        dialog.close()
        })
        
        
        
        dialog.addItem(item: "Failed",
                       icon:  #imageLiteral(resourceName: "ronock_logo"),
                       didTapHandler: { () in
                        self.viewModel.fetchFailed()
                        dialog.close()
        })
        
        
        
        dialog.addItem(item: "UnAuthorized",
                       icon:  #imageLiteral(resourceName: "ronock_logo"),
                       didTapHandler: { () in
                        self.viewModel.fetchUnAuthorized()
                        dialog.close()
        })
        
        
        dialog.addItem(item: "ForceUpdate",
                       icon:  #imageLiteral(resourceName: "ronock_logo"),
                       didTapHandler: { () in
                        self.viewModel.fetchForceUpdate()
                        dialog.close()
        })
        
        dialog.show()
        
    }
    var isRonockAssistantShown = false
    
    @IBAction func toggleLanguageClicked(_ sender: Any) {
        
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar-001" : "en")
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_LANGUAGE_CHANGED: MOLHLanguage.currentAppleLanguage()])
        
        MOLH.reset(transition: .transitionCrossDissolve)
        self.reset11()
    }
    
    func reset11() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "SplashVC")
    }
    
    @IBAction func toggleRonock(_ sender: Any) {
        if imageview == nil{
            setupRonockAssistant1(width: 100, height: 100)
        }else{
            imageview?.removeFromSuperview()
            imageview = nil
            
        }
    }
    
    @objc func draggedView(sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(imageview!)
        let translation = sender.translation(in: self.view)
        
        if imageview!.frame.minX <=  0{
            imageview!.center = CGPoint(x: imageview!.center.x + 1, y: imageview!.center.y)
            return
        }
        if (imageview!.frame.maxX) <= (self.view.frame.maxX){
            imageview!.center = CGPoint(x: imageview!.center.x + translation.x, y: imageview!.center.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }else{
            imageview!.center = CGPoint(x: self.view.frame.maxX - (imageview!.frame.width / 2), y: imageview!.center.y)
        }
    }
    
    @objc func ronockAssistantTapped(sender:UITapGestureRecognizer){
        
        if isRonockAssistantShown {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageview!.frame = CGRect(x: self.imageview!.frame.minX, y: self.view.frame.height - self.imageview!.frame.height, width: self.imageview!.frame.width, height: self.imageview!.frame.height)
            })
            hideRonockAssistantDetails()
            
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.imageview!.frame = CGRect(x: self.imageview!.frame.minX, y: UIApplication.shared.statusBarFrame.size.height + self.imageview!.frame.height / 2, width: self.imageview!.frame.width, height: self.imageview!.frame.height)
            })
            showRonockAssistantDetails()
        }
        
    }
    
    func setupRonockAssistant1(width: CGFloat, height: CGFloat) {
        imageview?.removeFromSuperview()
        imageview = nil
        do {
            let window = UIApplication.shared.keyWindow!
            
            let gif = try UIImage(gifName: self.selectedGIFImage)
            imageview = UIImageView(gifImage: gif, loopCount: -1)
            imageview?.frame =  CGRect(x: (window.frame.width - width - 5), y: (window.frame.height - height - 5), width: width, height: height)
            
            panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.draggedView(sender:)))
            imageview!.isUserInteractionEnabled = true
            imageview!.addGestureRecognizer(panGesture)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ronockAssistantTapped(sender:)))
            imageview?.addGestureRecognizer(tapRecognizer)
            
            window.addSubview(imageview ?? UIImageView());
            
        } catch {
            print(error)
        }
    }
    
    func showRonockAssistantDetails() {
        isRonockAssistantShown = true
        let window = UIApplication.shared.keyWindow!
        
        let overlay = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height))
        overlay.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        overlay.alpha = 0.6
        overlay.tag = 101
        
        let detialsView = RonockAssistantDetails(frame: CGRect(x: 0, y: window.frame.height, width: self.view.frame.width - 20, height: self.view.frame.height)).loadView();
        detialsView.frame = CGRect(x: 10, y: window.frame.height, width: self.view.frame.width - 20, height: self.view.frame.height)
        detialsView.tag = 100
        
        detialsView.ronockAssisSize = { type in
            self.hideRonockAssistantDetails()
            switch type{
            case 0:
                self.setupRonockAssistant1(width: 50, height: 50)
                break
            case 1:
                self.setupRonockAssistant1(width: 70, height: 70)
                break
            case 2:
                self.setupRonockAssistant1(width: 100, height: 100)
                break
            default:
                print("NotSelected")
            }
        }
        
        detialsView.smileClicked = {
            do {
                self.selectedGIFImage = "animations/smile_gif.gif"
                let gif = try UIImage(gifName: self.selectedGIFImage)
                self.imageview!.clear()
                self.imageview?.gifImage = gif
            } catch {
                print(error)
            }
        }
        
        detialsView.sadClicked = {
            do {
                self.selectedGIFImage = "animations/sad_gif.gif"
                let gif = try UIImage(gifName: self.selectedGIFImage)
                self.imageview!.clear()
                self.imageview?.gifImage = gif
            } catch {
                print(error)
            }
            
        }
        
        detialsView.ronockClicked = {
            do {
                self.selectedGIFImage = "animations/ronock_anim.gif"
                let gif = try UIImage(gifName: self.selectedGIFImage)
                self.imageview!.clear()
                self.imageview?.gifImage = gif
            } catch {
                print(error)
            }
            
        }
        
        window.addSubview(overlay)
        window.addSubview(detialsView)
        
        window.bringSubviewToFront(self.imageview!);
        
        UIView.animate(withDuration: 0.3, animations: {
            detialsView.frame = CGRect(x: 10, y:  self.imageview!.frame.maxY, width: self.view.frame.size.width - 20, height: window.frame.height - self.imageview!.frame.maxY)
        })
    }
    
    func hideRonockAssistantDetails() {
        let window = UIApplication.shared.keyWindow!
        isRonockAssistantShown = false
        var detailsView: RonockAssistantDetails?
        
        for a in window.subviews {
            if a.tag == 100{
                detailsView = a as? RonockAssistantDetails
            }
            if a.tag == 101{
                a.removeFromSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            detailsView?.frame = CGRect(x: 10, y:  window.frame.height, width: self.view.frame.size.width - 20, height: window.frame.height - self.imageview!.frame.maxY)
        }, completion: { isFinished in
            detailsView?.removeFromSuperview()
        })
        
    }
}
