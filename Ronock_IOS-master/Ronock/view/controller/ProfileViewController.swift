//
//  ProfileViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 10/15/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import AppCenterAnalytics
import AppCenterCrashes


class ProfileViewController: BaseTableViewController {
    
    let viewModel = ProfileViewModel(repository: Repository.shared)
 
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var profileLogo: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var stores: UILabel!
    @IBOutlet weak var intrests: UILabel!
    @IBOutlet weak var brands: UILabel!
    
    var vc: MyFavoriteViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error.localizedDescription)
            }
        }
        
        viewModel.didFinishFetch = { profile in
            self.profileLogo.downloaded(from: profile?.imageURL ?? "")
            self.userFullName.text = profile?.fullName
            self.userEmail.text = profile?.email
        }
        
        viewModel.fetchProfile()
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        vc?.changeCurrentPage(index: self.segmentedControll.selectedSegmentIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MyFavoriteViewController {
            vc = segue.destination as? MyFavoriteViewController
            vc?.didPageChanged = { index in
                print("Current Index : \(index)")
                self.segmentedControll.selectedSegmentIndex = index
            }
        }
    }
    
    @IBAction func editProfileClicked(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.fetchProfile()

        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "ProfileViewController"])
    }
    
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIApplication.shared.keyWindow!.frame.height * 1.5
//    }
}
