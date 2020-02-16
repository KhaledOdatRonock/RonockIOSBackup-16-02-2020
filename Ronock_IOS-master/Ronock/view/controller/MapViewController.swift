//
//  MapViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 10/30/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import GoogleMaps
import AppCenterAnalytics
import AppCenterCrashes
import SelectionDialog

/// Point of Interest Item which implements the GMUClusterItem protocol.
class ClusterItem: NSObject, GMUClusterItem {
  var position: CLLocationCoordinate2D
  var name: String!
    var mapLocation: MapLocation?
    var isSelected: Bool = false

  init(position: CLLocationCoordinate2D, name: String) {
    self.position = position
    self.name = name
  }
}

class MapViewController: BaseViewController, GMSMapViewDelegate, GMUClusterManagerDelegate {
    
    // MARK: - Injection
    let viewModel = MapViewModel(repository: Repository.shared)
    var tappedMarker : GMSMarker?
    var customInfoWindow : CustomInfoWindow?
    var initialMapLocation: CLLocationCoordinate2D?{
        didSet{
             DispatchQueue.main.async {
                let camera = GMSCameraPosition.camera(withLatitude: self.initialMapLocation!.latitude, longitude: self.initialMapLocation!.longitude, zoom: 8.0)
                self.mapView.animate(to:camera)
            }
            
        }
    }
    

    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupClusteringManager()
    
        self.tappedMarker = GMSMarker()
        mapView.delegate = self
                
        viewModel.didFinishFetch = { mapLocations in
            
            for mapLoc in mapLocations {
                var a = mapLoc
                if mapLoc.adType == Enums.MapLocationsType.SINGLE_AD.rawValue {
                    guard var currentAd = mapLoc.ads?[0] else { return }
                    self.viewModel.getImageFromURL(url: currentAd.adImage ?? "", completion: { image in
                        print("Ad Image Loaded")
                        currentAd.adImageUIImage = image
                        
                        a.ads?[0] = currentAd
                        
                        if currentAd.advLogoUIImage != nil {
                            DispatchQueue.main.async {
                                self.addMarker(mapLocation: a, type: Enums.MapLocationsType.SINGLE_AD.rawValue)
                            }
                        }
                    })
                    
                    self.viewModel.getImageFromURL(url: currentAd.advertiserLogo ?? "", completion: { image in
                        print("Advirtiser Logo Loaded")
                        currentAd.advLogoUIImage = image
                        if currentAd.adImageUIImage != nil {
                            DispatchQueue.main.async {
                                self.addMarker(mapLocation: a, type: Enums.MapLocationsType.SINGLE_AD.rawValue)
                            }
                        }
                    })
                }else if mapLoc.adType == Enums.MapLocationsType.MULTI_AD.rawValue{
                    DispatchQueue.main.async {
                    self.addMarker(mapLocation: mapLoc, type: Enums.MapLocationsType.MULTI_AD.rawValue)
                    }
                }
                
                self.initialMapLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(a.latitude ?? "0.0") ?? 0.0), longitude: CLLocationDegrees(Double(a.longitude ?? "0.0") ?? 0.0))
            }
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "MapViewController"])
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
            if selectedItem.mapLocation?.adType == Enums.MapLocationsType.SINGLE_AD.rawValue {
                print("SIngle Ad Selected")
                self.customInfoWindow = CustomInfoWindow().loadView(adObj: (selectedItem.mapLocation?.ads?[0])!)
                MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_MAP_AD_CLICKED: selectedItem.mapLocation?.ads?[0].name ?? ""])
            }else if selectedItem.mapLocation?.adType == Enums.MapLocationsType.MULTI_AD.rawValue{
                 print("Multi Ad Selected")
                self.customInfoWindow = CustomInfoWindow()
                self.multiAdPinTapped(ads: selectedItem.mapLocation!.ads!)
            }
        }
        
        
        
        return customInfoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let selectedAd = (marker.userData as! ClusterItem).mapLocation?.ads?[0]
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_MAP_AD_DETAILS_CLICKED: selectedAd?.name ?? ""])
        showAlert(title: selectedAd?.name ?? "", msg: "\(selectedAd?.advertiser) Selected", okHandler: {})
    }
    
    func multiAdPinTapped(ads: [Ad]) {

        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MultiAdsListViewController") as! MultiAdsListViewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.ads = ads
        
        viewController.didAdClicked = { ad in
            self.navigationController?.performSegue(withIdentifier: Constants.SegueIDs.MAP_TO_REGUALR_AD_SEGUE, sender: self)
            viewController.dismiss(animated: true, completion: nil)
        }
        present(viewController, animated: true, completion: nil)
    }
}

extension MapViewController: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        // if your marker is pointy you can change groundAnchor
        marker.groundAnchor = CGPoint(x: 0.5, y: 1)
        if  let markerData = (marker.userData as? ClusterItem) {
            if markerData.mapLocation?.adType == Enums.MapLocationsType.SINGLE_AD.rawValue {
                marker.icon = #imageLiteral(resourceName: "ronock_pin_48px")
            }else if markerData.mapLocation?.adType == Enums.MapLocationsType.MULTI_AD.rawValue{
                marker.icon = #imageLiteral(resourceName: "multi_ad_pin")
            }
        }
    }
}
