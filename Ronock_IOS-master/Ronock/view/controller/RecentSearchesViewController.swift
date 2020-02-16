//
//  RecentSearchesViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 1/22/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class RecentSearchesViewController: BaseViewController {

    var recentSearches: [RecentSearch]?{
        didSet{
           print("Loaded ")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let viewModel = RecentSearchesViewModel(repository: Repository.shared)

    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error.localizedDescription)
            }
        }
        
        viewModel.didFinishFetch = { recents in
            self.recentSearches = recents
        }
        
        viewModel.fetchRecentSearches()
    }
    
}

extension RecentSearchesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         guard let rowsCount = recentSearches?.count else { return 0}
         
         return rowsCount
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.RECENT_SEARCHES_TABLEVIEW_CELL, for: indexPath) as! RecentSearchesTableViewCell
         
        let currentRow = recentSearches?[indexPath.row]
         
        cell.recentSearch = currentRow
        
         return cell
         
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
     }
}
