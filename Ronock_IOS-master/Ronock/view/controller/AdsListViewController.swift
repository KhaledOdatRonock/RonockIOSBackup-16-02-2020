//
//  AdsListViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 11/5/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import GooglePlaces

class AdsListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Injection
    let viewModel = AdsListViewModel(repository: Repository.shared)
    
    var adsArray: [Ad]?
    var filter: String?{
        didSet{
            viewModel.fetchMapListAds()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.didFinishFetch = { mapAds in
            print("Ads List loaded success")
            self.adsArray = mapAds
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowsCount = adsArray?.count else { return 0}
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.ADS_LIST_CELL, for: indexPath) as! AdsListTableViewCell
        
        let currentRow = adsArray?[indexPath.row]
        
        cell.currentAd = currentRow
        
        cell.logoClicked = {
            let aa = self.parent as! AdvertismentsViewController
            aa.showAdvertiserProfile()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlert(title: "Selected Ad", msg: adsArray?[indexPath.row].name ?? "", okHandler: {})
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
}
