//
//  BottomSheetViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 10/20/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import CoreGraphics
import AppCenterAnalytics
import AppCenterCrashes


class BottomSheetViewController: BaseViewController {
    
    let viewModel = BottomSheetViewModel(repository: Repository.shared)
    var initialSheetY = 0.0
    var selectedSliceID: UnClipSliceParams?
    var dele: MyProtocol? = nil
    
    @IBOutlet weak var sheetTopBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchSliceDetails(sliceID: selectedSliceID?.sliceID ?? "", userId: "1ad5d117-c5e4-4886-b72a-b30cb41646c9")
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        sheetTopBar.addGestureRecognizer(gesture)
        
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error.localizedDescription)
            }
        }
        
        viewModel.didFinishFetch = { sliceDetailsResponse in
            print("sliceDetails fetched")
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "BottomSheetViewController"])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        initialSheetY = Double(view.frame.minY)
        print("Initial Y : \(initialSheetY)")
    }
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        let nextPosition = y + translation.y
        
        if Double(nextPosition) <= initialSheetY{
            return
        }
        
        self.view.frame = CGRect(x: 0, y: nextPosition, width: view.frame.width, height: view.frame.height)
        
        if (Double(nextPosition) - initialSheetY) > 100 {
            
            dismiss(animated: true, completion: nil)
        }else{
            if recognizer.state == .ended{
                self.view.frame = CGRect(x: 0, y: CGFloat(initialSheetY), width: view.frame.width, height: view.frame.height)
            }
        }
        
        recognizer.setTranslation(CGPoint(x: 0,y :0), in: self.view)
        
    }
    @IBAction func unclipClicked(_ sender: Any) {
        dele?.unCLipNow(sliceID: self.selectedSliceID!)
        dismiss(animated: true, completion: nil)
    }
    
}
