//
//  AdvertismentsViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 11/5/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import AppCenterAnalytics
import AppCenterCrashes
import GooglePlaces

class AdvertismentsViewController: BaseViewController {
    
     let viewModel = AdvertismentViewModel(repository: Repository.shared)
    
    var isMapShown = false
    var placesClient: GMSPlacesClient!
    var autoCompletePredictions: [GMSAutocompletePrediction]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var selectedPlace: GMSPlace?
    
    var adsListVC: AdsListViewController?
    var mapViewtVC: MapViewController?
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listViewContainer: UIView!
    @IBOutlet weak var recentSearchesContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        locationSearchBar.delegate = self
        definesPresentationContext = true
        
        placesClient = GMSPlacesClient.shared()
        

    }
    
    func getAutoCompletePredictions(query: String) {

        let token = GMSAutocompleteSessionToken.init()

          // Create a type filter.
          let filter = GMSAutocompleteFilter()
          filter.type = .establishment
        filter.country = "jo"
          placesClient?.findAutocompletePredictions(fromQuery: query,
                                                    bounds: nil,
                                                    boundsMode: GMSAutocompleteBoundsMode.bias,
                                                    filter: filter,
                                                    sessionToken: token,
                                                    callback: { (results, error) in
              if let error = error {
                print("Autocomplete error: \(error)")
                return
              }
              if let results = results {
                self.autoCompletePredictions = results
              }
          })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AdsListViewController {
            self.adsListVC = segue.destination as? AdsListViewController
        }else if segue.destination is MapViewController{
            self.mapViewtVC = segue.destination as? MapViewController
        }
    }
    @IBAction func switchListMap(_ sender: Any) {
        if isMapShown {
            showList()
        }else{
            showMap()
        }
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        adsListVC?.filter = searchBar.text
        showList()
        
        let recentSearch = RecentSearch()
        if selectedPlace != nil {
            
            recentSearch.placeID = selectedPlace?.placeID
            recentSearch.placeName = selectedPlace?.name
            recentSearch.query = searchBar.text
            viewModel.addRecentSearch(recentSearch: recentSearch)

        }
    }
    
    func showMap(){
        isMapShown = true
        tableView.alpha = 0
        recentSearchesContainer.alpha = 0
        mapViewContainer.alpha = 1
        listViewContainer.alpha = 0
    }
    
    func showList(){
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "AdsListViewController"])
        isMapShown = false
        tableView.alpha = 0
        recentSearchesContainer.alpha = 0
        mapViewContainer.alpha = 0
        listViewContainer.alpha = 1
    }
    
    
    func showRecentSearches(){
        isMapShown = false
        tableView.alpha = 0
        recentSearchesContainer.alpha = 1
        mapViewContainer.alpha = 0
        listViewContainer.alpha = 0
    }
    
    func showPlacesTableView(){
        isMapShown = false
        tableView.alpha = 1
        recentSearchesContainer.alpha = 0
        mapViewContainer.alpha = 0
        listViewContainer.alpha = 0
    }
    
    
    func showAdvertiserProfile() {
        self.performSegue(withIdentifier: Constants.SegueIDs.ADICON_TO_AVERTISER_PROFILE_SEGUE, sender: self)
    }
}

extension AdvertismentsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        if searchBar == self.locationSearchBar {
            self.getAutoCompletePredictions(query: searchText)
        }else if searchBar == self.searchBar{
            print("searchBarNorma")
        }
         
      }
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          
      }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel pressed")
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if searchBar == self.locationSearchBar {
            print("Location SearchBar Focused")
            self.showPlacesTableView()
        }else if searchBar == self.searchBar{
            print("Normal SearchBar Focused")
            self.showList()
        }
        
        return true
    }
    
}

extension AdvertismentsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = self.autoCompletePredictions?.count ?? 0
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsIDs.GOOGLE_PLACES_TABLEVIEW_CELL, for: indexPath) as! GooglePlacesTableViewCell
        
        let currentRow = autoCompletePredictions?[indexPath.row]
        
        cell.autoCompletePrediction = currentRow
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPrediction = autoCompletePredictions?[indexPath.row]
        self.activityIndicatorStart()
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue) )!
        
        placesClient.fetchPlace(fromPlaceID: selectedPrediction?.placeID ?? "", placeFields: fields, sessionToken: GMSAutocompleteSessionToken.init(), callback: {place, err in
            self.activityIndicatorStop()
            self.selectedPlace = place
            
            self.locationSearchBar.text = place?.name
            
            self.searchBar.becomeFirstResponder()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
