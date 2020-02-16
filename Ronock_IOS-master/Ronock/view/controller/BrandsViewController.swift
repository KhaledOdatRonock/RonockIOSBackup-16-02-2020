//
//  BrandsViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 1/19/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import AppCenterAnalytics
import AppCenterCrashes
import MaterialComponents.MaterialCards

class BrandsViewController: BaseViewController {
    
    var continuationToken = ""
    var filterTExt = ""
    var shouldReplaceBrands: Bool = false
    
    let viewModel = BrandsViewModel(repository: Repository.shared)
    var brandsList: [Brand] = []{
        didSet{
           DispatchQueue.main.async {
            self.collectionView.reloadData()
           }
        }
    }
        
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       collectionView.delegate = self
       collectionView.dataSource = self
       collectionView.setItemsInRow(items: 3)
       collectionView.allowsMultipleSelection = true
        searchBar.delegate = self
        let flowLAyout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLAyout.minimumLineSpacing = 10
        flowLAyout.minimumInteritemSpacing = 10
        
        viewModel.showAlertClosure = {
            
        }
        
        viewModel.updateLoadingStatus = {
            
        }
        
        viewModel.didFinishFetch = { intrests in
            self.activityIndicatorStop()
            print("Brands List loaded success")
            self.continuationToken = intrests?.continuationToken ?? ""
            if self.shouldReplaceBrands{
                self.brandsList = intrests?.items! ?? []
            }else{
                self.brandsList.append(contentsOf: intrests?.items! ?? [])
            }
        }
        
        viewModel.didIntrestsReplaced = {
            print("Replaced Success")
            
            //TODO:Perform Segua IntrestsToBrandsSegue
        }
        self.activityIndicatorStart()
        viewModel.fetchBrands(continuationToken: continuationToken, filterText: filterTExt)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "BrandsViewController"])
    }
}

extension BrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellsIDs.BRANDS_COLLECTIONVIEW_CELL, for: indexPath) as! BrandsCollectionViewCell

        let brand = brandsList[indexPath.row]

        brandCell.brand = brand
                
        return brandCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        brandsList[indexPath.row].isSelected = !(brandsList[indexPath.row].isSelected ?? false)
        
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.frame.width / 3) - 10
        return CGSize(width: cellSize , height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (brandsList.count) - 1 {  //numberofitem count
            if continuationToken.isEmpty{
                return
            }
            
                print("Load Next Batch")
            shouldReplaceBrands = false
            viewModel.fetchBrands(continuationToken: continuationToken, filterText: filterTExt)
            }
    }
}

extension BrandsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
               
        self.filterTExt = searchText
        self.continuationToken = ""
        
        let inputString = searchText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if inputString.count > 0{
            
            //TODO: Make Request for loading filtered items
        }else{
            self.filterTExt = ""
            self.continuationToken = ""
            shouldReplaceBrands = true
            viewModel.fetchBrands(continuationToken: continuationToken, filterText: filterTExt)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
        shouldReplaceBrands = true
        viewModel.fetchBrands(continuationToken: continuationToken, filterText: filterTExt)
    }
}
