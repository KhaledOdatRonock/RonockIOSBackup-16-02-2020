//
//  MultiAdsListViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/31/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class MultiAdsListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var ads: [Ad]?{
        didSet{
            
        }
    }
    var didAdClicked: ((_ clickedAd: Ad) -> ())!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowsCount = ads?.count else { return 0}
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.MULTI_AD_LIST_CELL, for: indexPath) as! MultiAdListTableViewCell
        
        let currentRow = ads?[indexPath.row]
        
        cell.ad = currentRow
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didAdClicked(ads![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265.0
    }
}
