//
//  FlyerListViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 11/17/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PagingTableView
import AppCenterAnalytics
import AppCenterCrashes

class FlyerListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, PagingTableViewDelegate {
    
    // MARK: - Injection
    let viewModel = FlyerListViewModel(repository: Repository.shared)
    
    var flyers: [Flyer] = []
    var selectedFlyerID: String?
    var contToken: String?
    
    @IBOutlet weak var tableView: PagingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pagingDelegate = self
        
        viewModel.didFinishFetch = { flyerList in
            self.activityIndicatorStop()
            print("Ads List loaded success")
            self.contToken = flyerList.continuationToken ?? ""
            self.flyers.append(contentsOf: flyerList.items!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        self.activityIndicatorStart()
        viewModel.fetchFlyers(continuationToken: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "FlyerListViewController"])
    }
    
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        if !(contToken?.isEmpty ?? true) {
            viewModel.fetchFlyers(continuationToken: contToken ?? "")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = flyers.count
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.FLYER_LIST_CELL, for: indexPath) as! FlyerListTableViewCell
        
        let currentRow = flyers[indexPath.row]
        
        cell.currentFlyer = currentRow
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FlyerViewerViewController") as! FlyerViewerViewController
        selectedFlyerID = flyers[indexPath.row].flyerID
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FLYER_CLICKED: selectedFlyerID ?? ""])
        
        viewController.flyerID = selectedFlyerID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is FlyerViewerViewController
        {
            let vc = segue.destination as? FlyerViewerViewController
            vc?.flyerID? = selectedFlyerID ?? ""
        }
    }
}
