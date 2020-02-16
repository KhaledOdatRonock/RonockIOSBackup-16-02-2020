//
//  RonockAssistant.swift
//  Ronock
//
//  Created by Khaled Odat on 12/16/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import Lottie

class RonockAssistant {
    let view: UIView!
    var imageview = AnimationView()
    var panGesture = UIPanGestureRecognizer()
    var selectedGIFImage = "animations/ronock_anim.gif"
    var isRonockAssistantShown = false
    var tabBarHeight: CGFloat = 0.0
    
    init(view: UIView, tabBarHeight: CGFloat){
        self.view = view
        self.tabBarHeight = tabBarHeight
     }

    
    @objc func draggedView(sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(imageview)
        let translation = sender.translation(in: self.view)
        
        if imageview.frame.minX <=  0{
            imageview.center = CGPoint(x: imageview.center.x + 1, y: imageview.center.y)
            return
        }
        if (imageview.frame.maxX) <= (self.view.frame.maxX){
            imageview.center = CGPoint(x: imageview.center.x + translation.x, y: imageview.center.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }else{
            imageview.center = CGPoint(x: self.view.frame.maxX - (imageview.frame.width / 2), y: imageview.center.y)
        }
    }
    
    @objc func ronockAssistantTapped(sender:UITapGestureRecognizer){
        
        if isRonockAssistantShown {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageview.frame = CGRect(x: self.imageview.frame.minX, y: self.view.frame.height - self.imageview.frame.height - self.tabBarHeight, width: self.imageview.frame.width, height: self.imageview.frame.height)
            })
            hideRonockAssistantDetails()
            
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.imageview.frame = CGRect(x: self.imageview.frame.minX, y: UIApplication.shared.statusBarFrame.size.height + self.imageview.frame.height / 2, width: self.imageview.frame.width, height: self.imageview.frame.height)
            })
            showRonockAssistantDetails()
        }
        
    }
    
    func setupRonockAssistant(width: CGFloat, height: CGFloat) {
        imageview.removeFromSuperview()
        imageview = AnimationView()
        do {
            let window = UIApplication.shared.keyWindow!
//
//            let gif = try UIImage(gifName: self.selectedGIFImage)
//            imageview = UIImageView(gifImage: gif, loopCount: -1)
            
            imageview.loopMode = .loop
                        
            Animation.loadedFrom(url: URL(string: "https://partnerdev.blob.core.windows.net/ronockfiles/aronock_assistant.json")!, closure: {animation in
                        self.imageview.animation = animation
                        self.imageview.play()
                
                

                self.imageview.tag = 2001
                self.imageview.frame =  CGRect(x: (window.frame.width - width - 5), y: (window.frame.height - height - self.tabBarHeight - 5), width: width, height: height)
                
                self.panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.draggedView(sender:)))
                self.imageview.isUserInteractionEnabled = true
                self.imageview.addGestureRecognizer(self.panGesture)
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ronockAssistantTapped(sender:)))
                self.imageview.addGestureRecognizer(tapRecognizer)
                
                if UserDefaults.standard.bool(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_RONOCK_ASSISTANT_STARTUP) {
                           self.showRonock()
                }
                
                    }, animationCache: LRUAnimationCache.sharedCache)
                
                
        } catch {
            print(error)
        }
    }
    
    func showRonock() {
         let window = UIApplication.shared.keyWindow!
        window.viewWithTag(2001)?.removeFromSuperview()
        window.addSubview(imageview ?? AnimationView());
    }
    
    func hideRonock() {
         let window = UIApplication.shared.keyWindow!
        window.viewWithTag(2001)?.removeFromSuperview()
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
                self.setupRonockAssistant(width: 50, height: 50)
                break
            case 1:
                self.setupRonockAssistant(width: 70, height: 70)
                break
            case 2:
                self.setupRonockAssistant(width: 100, height: 100)
                break
            default:
                print("NotSelected")
            }
        }
        
        detialsView.smileClicked = {
            do {
//                self.selectedGIFImage = "animations/smile_gif.gif"
//                let gif = try UIImage(gifName: self.selectedGIFImage)
//                self.imageview!.clear()
//                self.imageview?.gifImage = gif
            } catch {
                print(error)
            }
        }
        
        detialsView.sadClicked = {
            do {
//                self.selectedGIFImage = "animations/sad_gif.gif"
//                let gif = try UIImage(gifName: self.selectedGIFImage)
//                self.imageview!.clear()
//                self.imageview?.gifImage = gif
            } catch {
                print(error)
            }
            
        }
        
        detialsView.ronockClicked = {
            do {
//                self.selectedGIFImage = "animations/ronock_anim.gif"
//                let gif = try UIImage(gifName: self.selectedGIFImage)
//                self.imageview!.clear()
//                self.imageview?.gifImage = gif
            } catch {
                print(error)
            }
            
        }
        
        window.addSubview(overlay)
        window.addSubview(detialsView)
        
        window.bringSubviewToFront(self.imageview);
        
        UIView.animate(withDuration: 0.3, animations: {
            detialsView.frame = CGRect(x: 10, y:  self.imageview.frame.maxY, width: self.view.frame.size.width - 20, height: window.frame.height - self.imageview.frame.maxY)
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
            detailsView?.frame = CGRect(x: 10, y:  window.frame.height, width: self.view.frame.size.width - 20, height: window.frame.height - self.imageview.frame.maxY)
        }, completion: { isFinished in
            detailsView?.removeFromSuperview()
        })
        
    }
}
