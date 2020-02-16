//
//  HomeStoryHeaderTableViewCell.swift
//  Ronock
//
//  Created by Khaled Odat on 1/6/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit

class HomeStoryHeaderTableViewCell: UITableViewCell {

    var stories: [Story]?{
        didSet{
            DispatchQueue.main.async {
                self.storiesCollectionView.reloadData()
            }
        }
    }
    
    var didStoryClicked: ((_ story: Story?, _ position: Int) -> ())?
    
    
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
    }

}


extension HomeStoryHeaderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stories?.count ?? 0
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let  storyCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellsIDs.STORIES_CELL, for: indexPath) as! StoriesCollectionViewCell
        
           let story = stories?[indexPath.row]
           
           storyCell.story = story
                   
           return storyCell
       }

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = stories?[indexPath.row]
        if (didStoryClicked != nil) {
            didStoryClicked!(selectedItem, indexPath.row)
        }
           
           
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 90, height: 90)
       }
}
