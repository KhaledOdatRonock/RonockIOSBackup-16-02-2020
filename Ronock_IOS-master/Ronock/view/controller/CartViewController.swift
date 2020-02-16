//
//  CartViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 11/14/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import AppCenterAnalytics
import AppCenterCrashes

class CartViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cartHeaders: [CartHeader]?{
        didSet{
            if let headers = cartHeaders{
                //TODO: refresh the collection view
                print(headers)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    let viewModel = CartViewModel(repository: Repository.shared)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        setupLongPressGesture()
        
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error.localizedDescription)
            }
        }
        
        viewModel.didFinishFetch = { cartHeaders1 in
            print(cartHeaders1)
            self.cartHeaders = cartHeaders1
        }
        
        viewModel.fetchMyCart()
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        self.collectionView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {

            let touchPoint = sender.location(in: self.collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {

                let clip = cartHeaders![indexPath.section].clippedItem![indexPath.row]
                viewModel.remoceCart(sliceId: clip.sliceId ?? "")
                cartHeaders![indexPath.section].clippedItem!.remove(at: indexPath.row)
                
                if cartHeaders![indexPath.section].clippedItem!.isEmpty {
                    cartHeaders!.remove(at: indexPath.section)
                }
                self.collectionView.reloadData()
                //TODO: Rempve item and reload collectionview
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "CartViewController"])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cartHeaders?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartHeaders?[section].clippedItem?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let  headerView: CartHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartHeaderCollectionReusableView", for: indexPath) as! CartHeaderCollectionReusableView
            headerView.cartHeader = cartHeaders?[indexPath.section]
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cartItemCell: CartItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartItemCollectionViewCell", for: indexPath) as! CartItemCollectionViewCell
        
        let cartItem = cartHeaders?[indexPath.section].clippedItem?[indexPath.row]
        
        cartItemCell.cartItem = cartItem
        
        return cartItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = cartHeaders?[indexPath.section].clippedItem?[indexPath.row]
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_SLICE_CART_CLICKED: selectedItem?.sliceId ?? ""])
        
        showAlert(title: "Item Tapped", msg: "\(selectedItem?.sliceId ?? "") Selected", okHandler: {})
    }
}
