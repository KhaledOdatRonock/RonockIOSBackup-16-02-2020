//
//  RonockAssistantDetails.swift
//  Ronock
//
//  Created by Khaled Odat on 12/2/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import SelectionDialog

class RonockAssistantDetails: UIView {
    
    let viewModel = RonockAssistantDetailsVeiwModel(repository: Repository.shared)
    var ronockAssisSize: ((Int) -> ())!
    var smileClicked: (() -> ())!
    var sadClicked: (() -> ())!
    var ronockClicked: (() -> ())!
    @IBOutlet weak var ronockBody: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadView() -> RonockAssistantDetails{
        let ronockAssisView = Bundle.main.loadNibNamed("RonockAssistantDetails", owner: self, options: nil)?[0] as! RonockAssistantDetails
        
        viewModel.showAlertClosure = {
            
        }
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.didFinishFetch = { intrests in
            
            
        }
        
        do {
            let selectedGIFImage = "animations/ronock_body.gif"
            let gif = try UIImage(gifName: selectedGIFImage)
            ronockAssisView.ronockBody.setImage(gif)
        } catch {
            print(error)
        }
                
        ronockAssisView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        ronockAssisView.layer.borderWidth = 1
        ronockAssisView.layer.masksToBounds = true
        
        ronockAssisView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ronockAssisView.layer.shadowOpacity = 0.8
        ronockAssisView.layer.shadowOffset = CGSize(width: 10, height: 10)
        ronockAssisView.layer.shadowRadius = 20
        
        return ronockAssisView
    }
    
    @IBAction func smileCLicked(_ sender: Any) {
        self.smileClicked()
    }
    @IBAction func sadClicked(_ sender: Any) {
        self.sadClicked()
    }
    @IBAction func ronockClicked(_ sender: Any) {
        self.ronockClicked()
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        let dialog = SelectionDialog(title: "Please select which size of Ronock Assistant you prefer", closeButtonTitle: "Close")
        
        dialog.addItem(item: "Small",
                       icon:  #imageLiteral(resourceName: "ronock_logo"),
                       didTapHandler: { () in
                        self.ronockAssisSize(0)
                        dialog.close()
        })
        
        
        dialog.addItem(item: "Medium",
                       icon:  #imageLiteral(resourceName: "ronock_logo"),
                       didTapHandler: { () in
                        self.ronockAssisSize(1)
                        dialog.close()
        })
        
        
        
        dialog.addItem(item: "Large",
                       icon:  #imageLiteral(resourceName: "ronock_logo"),
                       didTapHandler: { () in
                        self.ronockAssisSize(2)
                        dialog.close()
        })
        
        dialog.show()
    }
}
