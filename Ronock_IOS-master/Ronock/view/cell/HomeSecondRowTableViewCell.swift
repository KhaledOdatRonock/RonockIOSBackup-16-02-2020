//
//  HomeSecondRowTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/8/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class HomeSecondRowTableViewCell: UITableViewCell {

    
    var hotDeals: [HomeAd]?{
        didSet{
            DispatchQueue.main.async {
                self.storiesCollectionView.reloadData()
                
                let middle = ((self.hotDeals?.count ?? 0) * 100) / 2
                self.storiesCollectionView.scrollToItem(at: IndexPath(row: middle, section: 0), at: .centeredHorizontally, animated: true)
                // ********** Below line produne error when scroll to specific indxPath. I will debug it later *********
//                self.storiesCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    var didDealClicked: ((_ hotDeal: HomeAd?) -> ())?
    var didSaveAdClicked: ((_ hotDeal: HomeAd?) -> ())?
    
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
        
        
        collectionViewFlowLayout = storiesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }

}


extension HomeSecondRowTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.hotDeals?.count ?? 0) * 100
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let  hotDealCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellsIDs.HOME_HOT_DEAL_CELL, for: indexPath) as! HomeHotDealItemCollectionViewCell
        
        let currentPos = indexPath.row % (self.hotDeals?.count ?? 0)
           let deal = hotDeals?[currentPos]
        hotDealCell.deal = deal
                   
        hotDealCell.didSaveAdClicked = { deal in
            self.didSaveAdClicked!(deal)
        }
           return hotDealCell
       }

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = hotDeals?[indexPath.row % (self.hotDeals?.count ?? 0)]

        if (didDealClicked != nil) {
            didDealClicked!(selectedItem)
        }

           
       }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.storiesCollectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.storiesCollectionView.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.storiesCollectionView.scrollToNearestVisibleCollectionViewCell()
    }
}
