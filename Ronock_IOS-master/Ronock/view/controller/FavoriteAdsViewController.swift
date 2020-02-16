//
//  FavoriteAdsViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 1/16/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PagingTableView
import AppCenterAnalytics
import AppCenterCrashes

class FavoriteAdsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: - Injection
          let viewModel = FavoriteAdsViewModel(repository: Repository.shared)
          
    var ads: [FavoriteAd] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var contToken = ""
    
    
    @IBOutlet weak var tableView: PagingTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.didFinishFetch = { adsList in
            self.activityIndicatorStop()
            print("Ads List loaded success")
            self.contToken = adsList.continuationToken ?? ""
            self.ads.append(contentsOf: adsList.items!)

        }
        self.activityIndicatorStart()
        viewModel.fetchFavoriteAds(continuationToken: contToken)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "FavoriteAdsViewController"])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  favCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.FAVORITE_ADS_TABLE_CELL, for: indexPath) as! FavoriteAdsTableViewCell

            let ad = ads[indexPath.row]

        favCell.ad = ad

            return favCell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141.0
    }
    
}
