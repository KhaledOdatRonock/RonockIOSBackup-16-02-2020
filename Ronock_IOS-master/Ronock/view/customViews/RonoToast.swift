//
//  RonoToast.swift
//  Ronock
//
//  Created by Khaled Odat on 1/26/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class RonoToast: UIView {

    static let shared: RonoToast = RonoToast()
    var customInfoWindow: UIView = UIView()
    let duartion = 2.5
    
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    private func show(){
        customInfoWindow.alpha = 0
        let window = UIApplication.shared.keyWindow!
        window.addSubview(customInfoWindow)
        UIView.animate(withDuration: 0.3, animations: {
            self.customInfoWindow.alpha = 1
        }){ finished in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.duartion) {
                self.hide()
            }
        }
    }
    
    @IBAction func dismissRonoToast(_ sender: Any) {
        hide()
       
    }
    
    private func hide(){
        let window = UIApplication.shared.keyWindow!
        let myView = window.viewWithTag(9999)
        
        UIView.animate(withDuration: 0.3, animations: {
            myView?.alpha = 0
        }){ finished in
            myView?.removeFromSuperview()
        }
    }
    
    func showToast(message: String, icon: UIImage){
         customInfoWindow = Bundle.main.loadNibNamed("RonoToast", owner: self, options: nil)?[0] as! RonoToast
        customInfoWindow.tag = 9999
        let window = UIApplication.shared.keyWindow!
        
        customInfoWindow.frame = CGRect(x: 20, y: 20, width: window.frame.width - 40, height: 60)
        customInfoWindow.alpha = 0
        (customInfoWindow as! RonoToast).iconImage.image = icon
        (customInfoWindow as! RonoToast).messageLabel.text = message
        window.addSubview(customInfoWindow)
        
        show()
        
            }
}
