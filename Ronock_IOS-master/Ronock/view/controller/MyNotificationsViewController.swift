//
//  MyNotificationsViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/23/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PagingTableView
import AppCenterAnalytics
import AppCenterCrashes

class MyNotificationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, PagingTableViewDelegate {
    
    // MARK: - Injection
     let viewModel = MyNotificationsViewModel(repository: Repository.shared)
    
    var notifications: [Notification] = []
    
    var contToken: String?
    
    @IBOutlet weak var tableView: PagingTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.pagingDelegate = self
        
        viewModel.showAlertClosure = {
            self.activityIndicatorStop()
        }
        viewModel.didFinishFetch = { adsList in
            self.activityIndicatorStop()
            self.contToken = adsList.continuationToken
            self.notifications.append(contentsOf: adsList.items!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        self.activityIndicatorStart()
        viewModel.fetchMyNotifications(continustionTOken: "")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "MyNotificationsViewController"])
    }
    func paginate(_ tableView: PagingTableView, to page: Int) {
        if !(contToken?.isEmpty ?? true) {
            viewModel.fetchMyNotifications(continustionTOken: contToken ?? "")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = notifications.count
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.MY_NOTIFICATIONS_CELL, for: indexPath) as! MyNotificationsTableViewCell
        
        let currentRow = notifications[indexPath.row]
        
        cell.notification = currentRow
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let markAsRead = UIContextualAction(style: .normal, title: "Mark as read") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            self.notifications[indexPath.row].isRead = !self.notifications[indexPath.row].isRead
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            self.notifications.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [markAsRead, delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
}
