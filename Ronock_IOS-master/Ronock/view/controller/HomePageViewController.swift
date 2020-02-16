//
//  HomePageViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/9/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import PMAlertController
import AppCenterAnalytics
import AppCenterCrashes

class HomePageViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel = HomePageViewModel(repository: Repository.shared)
    
    var adsList: [DealSection]?{
        didSet{
            
            let headerStory = DealSection(sectionID: -2, sectionName: "headerStory", sectionIcon: "", deals: [])
            adsList?.insert(headerStory, at: 0)
            
            let secondRowHotDeals = DealSection(sectionID: -1, sectionName: "HotDeals", sectionIcon: "", deals: [])
            adsList?.insert(secondRowHotDeals, at: 1)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var stories: [Story]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var hotDeals: [HomeAd]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedStory: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
        viewModel.showAlertClosure = {
            
        }
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.didFinishFetch = { ads in
            self.adsList = ads ?? []
            
            
        }
        
        viewModel.didFinishHotDeals = { deals in
            self.hotDeals = deals ?? []
            
            
        }
        
        viewModel.didFinishStories = { storiesList in
            self.stories = storiesList ?? []
            
        }
        
        viewModel.fetchHomePageAds()
        viewModel.fetchStories()
        viewModel.fetchHotDeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "HomePageViewController"])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentRow = adsList?[indexPath.row]

        if currentRow?.sectionID == -2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.HOME_STORY_HEADER_CELL, for: indexPath) as! HomeStoryHeaderTableViewCell

            cell.didStoryClicked = { story, pos in
                print("Story Clicked")
                self.selectedStory = pos
                self.performSegue(withIdentifier: Constants.SegueIDs.HOME_TO_STORY_VIEWER_SEGUE, sender: self)
            }
            
            cell.stories = stories ?? []
            return cell
        }
        
        if currentRow?.sectionID == -1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.HOME_SECOND_ROW_HOT_DEAL_CELL, for: indexPath) as! HomeSecondRowTableViewCell

            cell.didDealClicked = { hotDeal in
                print(hotDeal)
                self.whichAdTypeClicked(type: hotDeal?.type ?? -1)
            }
            
            cell.didSaveAdClicked = { deal in 
                print("Saved : \(deal)")
            }
            cell.hotDeals = hotDeals ?? []
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.HOME_PAGE_CELL, for: indexPath) as! HomePageTableViewCell
        cell.scrollToTopCollectionView()
        cell.didItemClicked = { item, type in
            //TODO: Open details of ad based on its type
            self.whichAdTypeClicked(type: type)
        }
        
        cell.didFooterClicked = { sectionID in
            print("(\(sectionID)) section footer clicked")
            //TODO: Open ads list by category
            if sectionID == 2 {
                self.performSegue(withIdentifier: Constants.SegueIDs.HOME_TO_FLYER_LIST_SEGUE, sender: self)
            }else{
                self.performSegue(withIdentifier: Constants.SegueIDs.HOME_TO_ADS_BY_CATEGORY_SEGUE, sender: self)
            }
        }
        
        cell.item = currentRow
        return cell
    }
    func whichAdTypeClicked(type: Int) {
        print("(\(type)) item clicked")
        if type == 2{
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "FlyerViewerViewController") as! FlyerViewerViewController
            viewController.flyerID = "2cf55311-7330-4a25-9902-1318228c7657"
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if type == 3 {
            self.performSegue(withIdentifier: Constants.SegueIDs.HOME_TOVIDEO_AD_DETAILS_SEGUE, sender: self)
        }else if type == 1{
            self.performSegue(withIdentifier: Constants.SegueIDs.HOME_TO_REGULAR_AD_DETAILS_SEGUE, sender: self)
        }else if type == 4{

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        
        return 223.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is StoryViewerViewController {
            let vc = segue.destination as! StoryViewerViewController
            vc.stories = self.stories
            vc.pos = self.selectedStory
            
            vc.didRegularAdClicked = {
                self.performSegue(withIdentifier: Constants.SegueIDs.HOME_TO_REGULAR_AD_DETAILS_SEGUE, sender: self)
            }
            
            vc.didVideoAdClicked = {
                self.performSegue(withIdentifier: Constants.SegueIDs.HOME_TOVIDEO_AD_DETAILS_SEGUE, sender: self)
            }
        }
    }
}

