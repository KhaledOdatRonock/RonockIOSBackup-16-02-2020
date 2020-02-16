//
//  DataService.swift
//  MVVM Alamofire
//
//  Created by Business Intelligence For Technology on 7/12/18.
//  Copyright © 2018 Business Intelligence For Technology. All rights reserved.
//

import Foundation
import Alamofire
import MOLH
import AppCenterAnalytics
import AppCenterCrashes

struct DataService {
    
    // MARK: - Singleton
    static let shared = DataService()
    
    // MARK: - URL
    private var photoUrl = "https://jsonplaceholder.typicode.com/photos"
    
    let sessionManager = Alamofire.SessionManager.default
    
    init() {
        sessionManager.adapter = MashapeHeadersAdapter()
    }
    
    
    // MARK: - Services
    func requestFetchPhoto(with id: Int, completion: @escaping (Photo?, Error?) -> ()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(photoUrl)/\(id)"
        sessionManager.request(url).responsePhoto { response in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "requestFetchPhoto")
            
            if let error = response.error {
                completion(nil, error)
                return
            }
            if let photo = response.result.value {
                completion(photo.data, nil)
                return
            }
        }
    }
    
    func fetchSliceDetails(sliceID: String, userID: String, completion: @escaping (SliceDetailsResponse?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)flyer/Slice?businessReferenceID=\(userID)&id=\(sliceID)"
        sessionManager.request(url).responseSliceDetials{ sliceDetails in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchSliceDetails")
            
            if let error = sliceDetails.error {
                completion(nil, error)
                return
            }
            
            if let sliceDetails = sliceDetails.result.value {
                completion(sliceDetails, nil)
            }
        }
    }
    
    func clipSlice(clipped: ClippedSliceParams, completion: @escaping (String?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Cart/AddClipToCart"
        
        let params = [
            "advertiserId":clipped.advertiserID,
            "advertiserName":clipped.advertiserName,
            "advertiserLogo":clipped.advertiserLogo,
            "expirydate":clipped.advertisementExpiryDate,
            "advertisementId":clipped.advertisementID,
            "sliceId":clipped.sliceID,
            "sliceURL":clipped.sliceURL
            
        ]
        sessionManager.request(url,method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON{
            (response) in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "clipSlice")
            
            completion(response.value as? String, response.error)
        }
        
    }
    
    
    func unClipSlice(clipped: UnClipSliceParams, completion: @escaping (String?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Cart/DeleteClipFromCart"
        
        let params = [
            "advertiserId":clipped.advertiserID,
            "sliceId":clipped.sliceID
            
        ]
        sessionManager.request(url,method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON{
            (response) in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "unClipSlice")
            
            completion(response.value as? String, response.error)
        }
        
    }
    
    func fetchMapListAds(completion: @escaping ([Ad]?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/SearchAds"
        sessionManager.request(url).responseMapListAdsResponse{ mapAds in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchMapAds")
            guard let webApiResponse = mapAds.result.value else { return }
            
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                completion(webApiResponse.data, nil)
            }
        }
    }
    
    
    func fetchMapLocationsAds(completion: @escaping (WebAPIResponse<[MapLocation]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/MapAds"
        sessionManager.request(url).responseMapLocationsResponse{ mapAds in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchMapLocationsAds")
            guard let webApiResponse = mapAds.result.value else { return }
            
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                completion(webApiResponse, nil)
            }
        }
    }
    
    
    func fetchSuccess(completion: @escaping (WebAPIResponse<[Catalog]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)HttpResponse/Success"
        sessionManager.request(url).responseSuccess{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchSuccess")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchDone(completion: @escaping (WebAPIResponse<[Ad]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)HttpResponse/Done"
        sessionManager.request(url, method: .post).responseDone{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchDone")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchFailed(completion: @escaping (WebAPIResponse<[Catalog]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)HttpResponse/Failed"
        sessionManager.request(url).responseFailed{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchFailed")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchUnAuthorized(completion: @escaping (WebAPIResponse<[Catalog]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)HttpResponse/UnAuthorized"
        sessionManager.request(url).responseUnAuthorized{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchUnAuthorized")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchForceUpdate(completion: @escaping (WebAPIResponse<[Catalog]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        
        let url = "\(Constants.Common.BASE_URL)HttpResponse/ForceUpdate"
        sessionManager.request(url).responseForceUpdate{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchForceUpdate")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchMyCart(completion: @escaping (WebAPIResponse<[CartHeader]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Cart/GetMyCart"
        sessionManager.request(url).responseMyCart{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchMyCart")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    
    func fetchFlyers(continustionTOken: String, completion: @escaping (WebAPIResponse<ListDataResponse<Flyer>>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Flyer/Flyers"
        sessionManager.request(url,method: .post, parameters: ["pageSize":5, "continuationToken":continustionTOken], encoding: JSONEncoding.default, headers: [:]).responseFlyers{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchFlyers")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
    func fetchProfile(completion: @escaping (WebAPIResponse<Profile>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)User/GetProfileDetails"
        
        sessionManager.request(url).responseProfile{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchProfile")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchIntrests(completion: @escaping (WebAPIResponse<[Intrest]>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Common/Interests"
        
        sessionManager.request(url).responseIntrests{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchIntrests")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    
    func silentNewUser(completion: @escaping (WebAPIResponse<String>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)User/CreateUser"
        
        sessionManager.request(url,method: .post, parameters: [:], encoding: JSONEncoding.default, headers: [:]).responseSilentNewUser{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "silentNewUser")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchAdvertiserPRofile(advertiserID: String, completion: @escaping (WebAPIResponse<AdvertiserProfile>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Advertiser/GetAdvertiserById?advertiserId=\(advertiserID)"
        
        sessionManager.request(url).responseAdvertiserProfile{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchAdvertiserPRofile")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchHomePageAds(completion: @escaping (WebAPIResponse<[DealSection]>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/Home"
        
        sessionManager.request(url).responseDeals{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchHomePageAds")
            
            guard let webApiResponse = apiResponse.result.value else { return }
            
            completion(webApiResponse, apiResponse.error)
            
        }
    }
    
    func fetchAdsByCategory(continustionTOken: String, completion: @escaping (WebAPIResponse<ListDataResponse<HomeAd>>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/GetAdsByCategory"
        
        let params = ["pageSize":5, "continuationToken":continustionTOken] as [String : Any]
        
        sessionManager.request(url).responseAdsByCategory{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchAdsByCategory")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
    
    func fetchVideoAdDetails(completion: @escaping (WebAPIResponse<VideoAdDetails>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/GetVideoAdDetails"
        
        sessionManager.request(url).responseVideoAdDetails{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchVideoAdDetails")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
    func fetchRegularAdDetails(completion: @escaping (WebAPIResponse<RegularAdDetails>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/GetRegularAdDetails"
        
        sessionManager.request(url).responseRegularAdDetails{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchVideoAdDetails")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
    func replaceIntrests(intrests: [Int], completion: @escaping (WebAPIResponse<String>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)User/ReplaceUserInterests"
        
        sessionManager.request(url,method: .post, parameters: ["ids":intrests], encoding: JSONEncoding.default, headers: [:]).responseReplaceIntrests{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "replaceIntrests")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
    func updateUserProfile(profile: Profile, completion: @escaping (WebAPIResponse<String>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)User/UpdateUser"
        
        let params = profile.toDict()
        
        sessionManager.request(url,method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseReplaceIntrests{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "updateUserProfile")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
    func fetchMyCoupons(completion: @escaping (WebAPIResponse<ListDataResponse<Coupon>>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)User/GetMyCoupons"
        
        sessionManager.request(url).responseMyCoupons{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchMyCoupons")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
      func fetchMyNotifications(continustionTOken: String, completion: @escaping (WebAPIResponse<ListDataResponse<Notification>>?,Error?) ->()) {
          let startTime = self.currentTimeInMilliSeconds()
          
          let url = "\(Constants.Common.BASE_URL)Notification/GetUserNotifications"
          
          let params = ["pageSize":5, "continuationToken":continustionTOken] as [String : Any]
          
          sessionManager.request(url).responseMyNotifications{ apiResponse in
              self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchMyNotifications")
              
              
              if let err = apiResponse.error{
                  completion(nil, err)
              }
              completion(apiResponse.result.value, apiResponse.error)
              
              
          }
      }
    
    
    func fetchCouponDetails(completion: @escaping (WebAPIResponse<CouponDetails>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/GetCouponDetails"
        
        sessionManager.request(url).responseCouponDetails{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchCouponDetails")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
    func uploadProfileImage(image: UIImage, completion: @escaping (WebAPIResponse<String>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)User/UpdateUserImage"
        
        let imgData = image.jpegData(compressionQuality: 0.2)!
        
        sessionManager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")},
                              to: url, encodingCompletion: {result in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    
                    self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "uploadProfileImage")
                    let apiResponse = try! JSONDecoder().decode(WebAPIResponse<String>.self, from: response.data!)
                    
                    completion(apiResponse, response.error)
                }

            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    func getImageFromURL(url: URL, completion: @escaping (UIImage?,Error?) ->()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    let errorTemp = NSError(domain:"", code:4444, userInfo:nil)
                    completion(nil, errorTemp)
                    return  }
            completion(image, nil)
        }.resume()
    }
    
    
    func fetchStories(completion: @escaping (WebAPIResponse<[Story]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/HomeStories"
        sessionManager.request(url).responseStory{ stories in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchStories")
            guard let webApiResponse = stories.result.value else { return }
            
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                completion(webApiResponse, nil)
            }
        }
    }
    
      func fetchHotDeals(completion: @escaping (WebAPIResponse<[HomeAd]>,Error?) ->()) {
          let startTime = self.currentTimeInMilliSeconds()
          
          let url = "\(Constants.Common.BASE_URL)Ads/HotDeals"
          sessionManager.request(url).responseHotDeals{ stories in
              self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchHotDeals")
              guard let webApiResponse = stories.result.value else { return }
              
              if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                  completion(webApiResponse, nil)
              }
          }
      }

    func fetchWalkthroughPages(completion: @escaping (WebAPIResponse<[WalkthroughPage]>,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Ads/WalkThroughPages"
        sessionManager.request(url).responseWalkthrough{ stories in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchWalkthroughPages")
            guard let webApiResponse = stories.result.value else { return }
            
            if webApiResponse.code == Enums.RequestResponse.SUCCESS.rawValue {
                completion(webApiResponse, nil)
            }
        }
    }
    
    
    func fetchFavoriteAds(continustionTOken: String, completion: @escaping (WebAPIResponse<ListDataResponse<FavoriteAd>>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)User/GetMyFavoriteAds"
        let params = ["pageSize":5, "continuationToken":continustionTOken] as [String : Any]
        
        sessionManager.request(url).responseFavouriteAds{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "fetchFavoriteAds")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
    
    func searchBrands(continustionTOken: String, filterText: String, completion: @escaping (WebAPIResponse<ListDataResponse<Brand>>?,Error?) ->()) {
        let startTime = self.currentTimeInMilliSeconds()
        
        let url = "\(Constants.Common.BASE_URL)Advertiser/SearchBrands"
        let params = ["pageSize":5, "continuationToken":continustionTOken, "filterText": filterText] as [String : Any]
        
        sessionManager.request(url,method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseBrands{ apiResponse in
            self.trackStartEndTime(startTime: startTime, endTime: self.currentTimeInMilliSeconds(), methodName: "searchBrands")
            
            
            if let err = apiResponse.error{
                print(err)
            }
            completion(apiResponse.result.value, apiResponse.error)
            
            
        }
    }
    
}

class MashapeHeadersAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        let lang = MOLHLanguage.currentAppleLanguage()
        let accessToken =  UserDefaults.standard.string(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN)
        urlRequest.setValue(lang, forHTTPHeaderField: "language")
        urlRequest.setValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
}

extension DataService{
    func trackStartEndTime(startTime: String, endTime: String, methodName: String) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_REQUEST_START_TIME: startTime, Constants.AppCenter.APP_CENTER_EVENT_KEY_REQUEST_END_TIME: endTime, Constants.AppCenter.APP_CENTER_EVENT_KEY_METHOD_NAME: methodName])
        
    }
    func currentTimeInMilliSeconds()-> String
    {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return "\(Int(since1970 * 1000))"
    }
}
