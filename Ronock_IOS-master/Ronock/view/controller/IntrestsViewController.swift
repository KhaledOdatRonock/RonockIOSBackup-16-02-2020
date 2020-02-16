//
//  IntrestsViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 11/27/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import AppCenterAnalytics
import AppCenterCrashes

class IntrestsViewController: BaseViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let viewModel = IntrestsViewModel(repository: Repository.shared)
    var intrestsList: [Intrest]?{
        didSet{
            if let intests = intrestsList{
                //TODO: refresh the collection view
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setItemsInRow(items: 3)
        collectionView.allowsMultipleSelection = true
        
        viewModel.showAlertClosure = {
            
        }
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.didFinishFetch = { intrests in
            self.intrestsList = intrests
            
            
            
        }
        
        viewModel.didIntrestsReplaced = {
            print("Replaced Success")
            
            //TODO:Perform Segua IntrestsToBrandsSegue
        }
        
        viewModel.fetchIntrests()
    }
    
    @IBAction func saveClicked1(_ sender: Any) {
        var selectedIntrests: [Int] = []
        
        for intrest in intrestsList! {
            if intrest.isSelected {
                selectedIntrests.append(intrest.interestID)
            }
        }
        
        viewModel.replaceIntrests(intrests: selectedIntrests)
    }
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "IntrestsViewController"])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intrestsList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  intrestCell: IntrestsUICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellsIDs.INTRESTS_LIST_CELL, for: indexPath) as! IntrestsUICollectionViewCell
        
        let intrest = intrestsList?[indexPath.row]
        
        intrestCell.intrestItem = intrest
                
        return intrestCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! IntrestsUICollectionViewCell
        
        intrestsList?[indexPath.row].isSelected = !(intrestsList?[indexPath.row].isSelected ?? false)
        
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
    
}
