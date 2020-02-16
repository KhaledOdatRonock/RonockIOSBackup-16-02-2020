//
//  HomePageTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 12/9/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {
    var item: DealSection?{
        didSet{
            self.headrTitle.text = item?.sectionName
            self.headerIcon.downloaded(from: item?.sectionIcon ?? "")
        }
    }
    
    var didItemClicked: ((_ item: HomeAd, _ btype: Int) -> ())?
    var didFooterClicked: ((_ type: Int) -> ())?
    var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    @IBOutlet weak var headrTitle: UILabel!
    @IBOutlet weak var headerIcon: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
    }

    func scrollToTopCollectionView() {
        collectionView.scrollToTop(animated: false)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension HomePageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item?.deals.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  dealCell: HomePageItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellsIDs.HOME_PAGE_ITEM_CELL, for: indexPath) as! HomePageItemCollectionViewCell

        dealCell.item = self.item?.deals[indexPath.row]
        
        return dealCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.CellsIDs.HOME_PAGE_FOOTER_CELL, for: indexPath) as! HomePageFooterCollectionReusableView

        
            footerView.categoryID = item!.sectionID
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapDetected(gesture:)))

            footerView.addGestureRecognizer(tapGestureRecognizer)
            
            return footerView
        default:
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didItemClicked!((item?.deals[indexPath.row])!, item?.deals[indexPath.row].type ?? -1)
    }
    
    @objc func tapDetected(gesture : UITapGestureRecognizer){
        let tappedCell = gesture.view as! HomePageFooterCollectionReusableView
        
        didFooterClicked!(tappedCell.categoryID)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }
}
