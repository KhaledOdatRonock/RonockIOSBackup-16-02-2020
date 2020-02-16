//
//  AdsByCategoryViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/15/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PagingTableView
import AppCenterAnalytics
import AppCenterCrashes

class AdsByCategoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, PagingTableViewDelegate {

    // MARK: - Injection
       let viewModel = AdsByCategoryViewModel(repository: Repository.shared)
       
       var ads: [HomeAd] = []
       var selectedAdID: String?
       var contToken: String?
    
    @IBOutlet weak var tableView: PagingTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pagingDelegate = self
        
        viewModel.didFinishFetch = { adsList in
            self.activityIndicatorStop()
            print("Ads List loaded success")
            self.contToken = adsList.continuationToken ?? ""
            self.ads.append(contentsOf: adsList.items!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        self.activityIndicatorStart()
        viewModel.fetchAdsByCategory(continuationToken: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "AdsByCategoryViewController"])
    }
    func paginate(_ tableView: PagingTableView, to page: Int) {
        if !(contToken?.isEmpty ?? true) {
            viewModel.fetchAdsByCategory(continuationToken: contToken ?? "")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = ads.count
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.ADS_BY_CATEGORY_CELL, for: indexPath) as! AdsByCategoryTableViewCell
        
        let currentRow = ads[indexPath.row]
        
        cell.item = currentRow
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    
}
