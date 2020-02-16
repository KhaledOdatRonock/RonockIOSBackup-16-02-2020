//
//  MyCouponsViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/18/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PagingTableView
import AppCenterAnalytics
import AppCenterCrashes

class MyCouponsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Injection
          let viewModel = MyCouponsViewModel(repository: Repository.shared)
          
    var ads: [Coupon] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
          var selectedAdID: String?
          var contToken: String?
    
    @IBOutlet weak var tableView: PagingTableView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.didFinishFetch = { adsList in
            self.activityIndicatorStop()
            print("Ads List loaded success")
            self.contToken = adsList.continuationToken ?? ""
            self.ads.append(contentsOf: adsList.items!)

        }
        self.activityIndicatorStart()
        viewModel.fetchMyCoupons()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "MyCouponsViewController"])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  couponCell: MyCouponTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.MY_COUPONS_CELL, for: indexPath) as! MyCouponTableViewCell

            let coupon = ads[indexPath.row]

        couponCell.item = coupon

            return couponCell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = ads[indexPath.row]
                   if selectedItem.type == 1 { //Regular Ad
                       self.performSegue(withIdentifier: Constants.SegueIDs.MY_COUPONS_TO_REGULAR_SEGUE, sender: self)
                   }else if selectedItem.type == 3{ // Video Ad
                        self.performSegue(withIdentifier: Constants.SegueIDs.MY_COUPONS_TO_VIDEO_SEGUE, sender: self)
                   }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
