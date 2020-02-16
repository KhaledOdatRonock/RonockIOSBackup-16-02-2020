//
//  AdsNearByViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 1/13/20.
//  Copyright © 2020 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import GoogleMaps
import AppCenterAnalytics
import AppCenterCrashes
import CoreLocation
import SelectionDialog

class AdsNearByViewController: BaseViewController, GMSMapViewDelegate, GMUClusterManagerDelegate {

    // MARK: - Injection
      let viewModel = AdsNearbyViewModel(repository: Repository.shared)
      var tappedMarker : GMSMarker?
      var customInfoWindow : CustomInfoWindow?
      let locationManager = CLLocationManager()
      let userMarker = GMSMarker()
    var lastItemVisible = -1

      var currentUserLocation: CLLocationCoordinate2D?{
          didSet{
              userMarker.position = CLLocationCoordinate2D(latitude: currentUserLocation!.latitude, longitude: currentUserLocation!.longitude)
              userMarker.map = self.mapView
               DispatchQueue.main.async {
                  let camera = GMSCameraPosition.camera(withLatitude: self.currentUserLocation!.latitude, longitude: self.currentUserLocation!.longitude, zoom: 15.0)
                  self.mapView.animate(to:camera)
              }
              
          }
      }
    var ads: [MapLocation]?{
        didSet{
             DispatchQueue.main.async {
                self.horizontalAdsList.reloadData()
            }
        }
    }

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var horizontalAdsList: UICollectionView!
    var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    private var clusterManager: GMUClusterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        horizontalAdsList.dataSource = self
        horizontalAdsList.delegate = self
        collectionViewFlowLayout = horizontalAdsList.collectionViewLayout as! UICollectionViewFlowLayout
        
        setupLocationManager()
            setupClusteringManager()
            userMarker.icon = #imageLiteral(resourceName: "user_location_pin-1")
            
        
            self.tappedMarker = GMSMarker()
            mapView.delegate = self
                    
            viewModel.didFinishFetch = { mapLocations in
                self.ads = mapLocations
                self.reloadMarkers()
            }
            
            viewModel.fetchMapAds()

    }
    
    
    func setupClusteringManager()  {
        // Set up the cluster manager with default icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)

        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    
    func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "AdsNearByViewController"])
    }
    
    func addMarker(mapLocation: MapLocation, type: Int) {
        let item = ClusterItem(position: CLLocationCoordinate2DMake(Double(mapLocation.latitude ?? "0.0")!, Double(mapLocation.longitude ?? "0.0")!), name: "aaaaa")
        item.mapLocation = mapLocation
        clusterManager.add(item)
        
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        if marker.userData is GMUCluster{ // Cluster Clicked
            let cluster = marker.userData as! GMUCluster
            let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
              zoom: mapView.camera.zoom + 2)
            let update = GMSCameraUpdate.setCamera(newCamera)
            mapView.moveCamera(update)

        }else if marker.userData is ClusterItem{ //Cluster Item Clicked
            let selectedItem = marker.userData as! ClusterItem
            let indexPath = getIndexPathForLocation(latitude: selectedItem.position.latitude, longitude: selectedItem.position.longitude)
            horizontalAdsList.scrollToItem(at: indexPath, at: .right , animated: true)
            
        }



        return customInfoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        return false
    }
    
    func getIndexPathForLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> IndexPath {
        for i in 0...(ads?.count ?? 0) - 1 {
            let ad = ads?[i]
            if CLLocationDegrees(Double(ad?.latitude ?? "0.0") ?? 0.0) == latitude && CLLocationDegrees(Double(ad?.longitude ?? "0.0") ?? 0.0) == longitude{
                return IndexPath(row: i, section: 0)
            }
        }
        
        return IndexPath(row: 0, section: 0)
    }
    
    func multiAdPinTapped(ads: [Ad]) {

        let viewController = UIStoryboard(name: "UnImplemented", bundle: nil).instantiateViewController(withIdentifier: "MultiAdsListViewController") as! MultiAdsListViewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.ads = ads
        
        viewController.didAdClicked = { ad in
            self.navigationController?.performSegue(withIdentifier: Constants.SegueIDs.MAP_TO_REGUALR_AD_SEGUE, sender: self)
            viewController.dismiss(animated: true, completion: nil)
        }
        present(viewController, animated: true, completion: nil)
    }
}

extension AdsNearByViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if self.currentUserLocation == nil{
            self.currentUserLocation = locValue
        }
    }
}


extension AdsNearByViewController: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        // if your marker is pointy you can change groundAnchor
        marker.groundAnchor = CGPoint(x: 0.5, y: 1)
        if  let markerData = (marker.userData as? ClusterItem) {
            
            if markerData.mapLocation?.isSelected ?? false{
                marker.icon = #imageLiteral(resourceName: "ronock_logo_hilighted_48px")
            }else{
                marker.icon = #imageLiteral(resourceName: "ronock_pin_48px")
            }
        }
    }
}

extension AdsNearByViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  adCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellsIDs.NEARBY_ADS_HORIZONTAL_CELL, for: indexPath) as! NearbyAdsHorizontalCollectionViewCell
        
        let adItem = ads?[indexPath.row]
        
        adCell.ad = adItem
        adCell.cellIndex = indexPath.row
        return adCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = ads?[indexPath.row]
        
        if selectedItem?.adType == Enums.MapLocationsType.SINGLE_AD.rawValue{
            self.navigationController?.performSegue(withIdentifier: Constants.SegueIDs.MAP_TO_REGUALR_AD_SEGUE, sender: self)
        }else if selectedItem?.adType == Enums.MapLocationsType.MULTI_AD.rawValue{
            multiAdPinTapped(ads: selectedItem?.ads ?? [])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width - 10, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.horizontalAdsList.scrollToNearestVisibleCollectionViewCell()
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.horizontalAdsList.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.horizontalAdsList.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        handleHorizontalStopSnapped()
    }
    
    func highlitMarker(id: Int) {
        for i in 0...((ads?.count ?? 0) - 1){
            if ads?[i].ads?[0].id == id {
                ads?[i].isSelected = true
            }else{
                ads?[i].isSelected = false
            }
        }
        
        reloadMarkers()
    }
    
    func handleHorizontalStopSnapped(){

        let firstVisibleCell = horizontalAdsList.visibleCells[0] as! NearbyAdsHorizontalCollectionViewCell

        if (firstVisibleCell.cellIndex ?? 0) == lastItemVisible {
            return
        }
        let visibleAd = ads?[firstVisibleCell.cellIndex ?? 0]
        DispatchQueue.main.async {
            
            let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Double(visibleAd?.latitude ?? "") ?? 0.0), longitude:  CLLocationDegrees(Double(visibleAd?.longitude ?? "") ?? 0.0), zoom: 17.0)
            self.mapView.animate(to:camera)
            self.highlitMarker(id: visibleAd?.ads?[0].id ?? 0)
            self.lastItemVisible = firstVisibleCell.cellIndex ?? 0
        }
    }
    
    func reloadMarkers() {
        clusterManager.clearItems()
        mapView.clear()
        
        userMarker.map = mapView

        for mapLoc in ads! {
            let a = mapLoc
            if mapLoc.adType == Enums.MapLocationsType.SINGLE_AD.rawValue {
                DispatchQueue.main.async {
                    self.addMarker(mapLocation: a, type: Enums.MapLocationsType.SINGLE_AD.rawValue)
                }
            }else if mapLoc.adType == Enums.MapLocationsType.MULTI_AD.rawValue{
                DispatchQueue.main.async {
                self.addMarker(mapLocation: mapLoc, type: Enums.MapLocationsType.MULTI_AD.rawValue)
                }
            }
            
        }
    }

}
