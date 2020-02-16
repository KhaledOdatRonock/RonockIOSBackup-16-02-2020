//
//  RegularAdDetailsViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/17/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import NBBottomSheet

class RegularAdDetailsViewController: BaseViewController {

    let viewModel = RegularAdDetailsViewModel(repository: Repository.shared)
      
      var regularAd: RegularAdDetails?{
          didSet{
            self.adImage.downloaded(from: regularAd?.thumbnail ?? "")
            self.advertiserImage.downloaded(from: regularAd?.advertiserLogo ?? "")
            
            self.adTitle.text = regularAd?.title ?? ""
            self.expiryDays.text = "Ends in \(regularAd?.expiryDays ?? 0) days"
            
            if !(regularAd?.hasCoupon ?? false) {
                hasCouponeLayout.removeFromSuperview()
            }
          }
      }
      
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var advertiserImage: UIImageView!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var favs: UILabel!
    @IBOutlet weak var shares: UILabel!
    @IBOutlet weak var expiryDays: UILabel!
    @IBOutlet weak var hasCouponeLayout: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views.set(text: "\(regularAd?.expiryDays ?? 0)", leftIcon: #imageLiteral(resourceName: "view"), rightIcon: nil)
        favs.set(text: "\(regularAd?.expiryDays ?? 0)", leftIcon: #imageLiteral(resourceName: "favorite-heart-button_16px").maskWithColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), rightIcon: nil)
        shares.set(text: "\(regularAd?.expiryDays ?? 0)", leftIcon: #imageLiteral(resourceName: "share").maskWithColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), rightIcon: nil)
        
               viewModel.showAlertClosure = {
                   
               }
               
               viewModel.updateLoadingStatus = {
                   
               }
               
               viewModel.didFinishFetch = { regularAdDetails in
                   self.regularAd = regularAdDetails
                   print(regularAdDetails)
               }
               
               viewModel.fetchRegularAdDetails()
    }

    @IBAction func shareClicked(_ sender: Any) {
        self.regularAd?.title.share()
    }
    @IBAction func adWebsiteClicked(_ sender: Any) {
          self.performSegue(withIdentifier: Constants.SegueIDs.REGULAR_AD_DETAILS_TO_WEBVIEW_SEGUE, sender: self)
    }
    
    @IBAction func redeemClicked(_ sender: Any) {
        let bottomSheetController = NBBottomSheetController()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        viewController.couponID = "3e3e3e-e3e33e3e3-e3"
        bottomSheetController.present(viewController, on: self)
    }
    @IBAction func saveCouponClicked(_ sender: Any) {
        showAlert(title: "Coupon Saved", msg: "Coupon has been saved to your wallet", okHandler: {})
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is WebViewViewController {
            let vc = segue.destination as! WebViewViewController
            vc.webURL = self.regularAd?.adPageURL ?? ""
        }
    }
}
