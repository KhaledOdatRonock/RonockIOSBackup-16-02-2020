//
//  VideoAdDetailsViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/11/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PMAlertController
import NBBottomSheet

class VideoAdDetailsViewController: BaseViewController {

     let viewModel = VideoAdDetailsViewModel(repository: Repository.shared)
    
    var videoAd: VideoAdDetails?{
        didSet{
            self.videoThumb.downloaded(from: videoAd?.thumbnail ?? "")
            self.advertiserLogo.downloadedFrom2(link: videoAd?.advertiserLogo ?? "")
            self.expiryDay.text = "Ends in \(videoAd?.expiryDays ?? 0) days"
            self.titleTV.text = videoAd?.title
            self.descriptionTV.text = videoAd?.videoAdDetailsDescription
            
            if !(videoAd?.hasCoupon ?? false) {
                hasCouponLayoyt.removeFromSuperview()
            }
        }
    }
    
    @IBOutlet weak var videoThumb: UIImageView!
    @IBOutlet weak var advertiserLogo: UIButton!
    @IBOutlet weak var expiryDay: UILabel!
    @IBOutlet weak var titleTV: UILabel!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var hasCouponLayoyt: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.showAlertClosure = {
            
        }
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.didFinishFetch = { videoDetails in
            self.videoAd = videoDetails
            print(videoDetails)
        }
        
        viewModel.fetchVideoAdDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playClicked(_ sender: Any) {
        let videoURL = URL(string: self.videoAd?.videoURL ?? "")!
        
        let youtubeId = videoURL.valueOf("v")
        var url = URL(string:"youtube://\(youtubeId ?? "")")!
        if !UIApplication.shared.canOpenURL(url)  {
            url = videoURL
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func viewWebsiteClicked(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.SegueIDs.VIDEO_DETAILS_TO_WEBVIEW_SEGUE, sender: self)
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        self.videoAd?.title.share()
    }
    
    @IBAction func likeClicked(_ sender: Any) {
        let alertVC = PMAlertController(title: "Ad Liked", description: "You Liked this ad successfuly", image: #imageLiteral(resourceName: "dialog_header"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: {}))
        
        self.present(alertVC, animated: true, completion: nil)
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
            vc.webURL = self.videoAd?.adPageURL ?? ""
        }
    }
}
