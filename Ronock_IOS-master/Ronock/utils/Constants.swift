//
//  Constants.swift
//  MVVM Alamofire
//
//  Created by Khaled Odat on 7/10/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation

public class Constants{
    
    public class Common{
        //Common Variables
        //        static let BASE_URL = "http://172.16.45.14/MobileWebServices/api/"
        static let BASE_URL = "http://ronockwebapi.azurewebsites.net/api/"
        
        static let GOOGLE_MAP_API_KEY = "AIzaSyDGV3QFCdI68wAy3Ubrlm7wheZyaw2ogws"
        static let GOOGLE_PLACES_API_KEY = "AIzaSyCx4w-Ccb_JkbgHWmdkQX8VUWe88fNEIYM"
    }
    
        public class B2cConfiguration{
            //AD B2C Configuration
            static let ENDPOINT_URL = "https://RonockDevP.b2clogin.com/tfp/%@/%@"
            static let TENANT = "RonockDevP.onmicrosoft.com"
            static let CLIENT_ID = "a2715882-53ea-4c49-a1b7-f7eff07625ac"
            static let SCOPES: [String] = ["https://RonockDevP.onmicrosoft.com/MobileAPI/read",
                                           "https://RonockDevP.onmicrosoft.com/MobileAPI/write",
                                           "https://RonockDevP.onmicrosoft.com/MobileAPI/user_impersonation"]
            static let SISU_POLICY = "B2C_1A_SignUpOrSignInWithPhone"
    //        public static let SISU_POLICY = "B2C_1A_SignUpOrSignInWithPhone"
            public static let EDIT_PROFILE_POLICY = "B2C_1_ProfileEditingMobile"
            public static let RESET_PASSWORD_POLICY = "B2C_1_PasswordResetMobile"
        }
    public class SharedPreferencesKeys{
        //Common SharedPreferneces Keys
        static let PREFS_KEY_DISPLAY_NAME = "display_name_claim"
        static let PREFS_KEY_ACCESS_TOKEN = "access_token"
        static let PREFS_KEY_LOGGED_IN = "is_logged_in"
        static let PREFS_KEY_CITY = "city_claim"
        static let PREFS_KEY_NAME = "name_claim"
        static let PREFS_KEY_JOB_TITLE = "job_title_claim"
        static let PREFS_KEY_FAMILY = "family_name_claim"
        static let PREFS_KEY_SHOULD_SLICES_SHOWN = "should_slices_shown"
        static let PREFS_KEY_LANGUAGE = "language"
        static let PREFS_KEY_SESSION_ID = "session_id"
        static let PREFS_KEY_RONOCK_ASSISTANT_STARTUP = "ronock_assistant_startup"
        static let PREFS_KEY_NOT_FIRST_TIME = "isNotFirstTime"
    }
    
    //Common ViewControllers identifiers
    
    public class SegueIDs{
        //Common Segue idnitifiers
        static let SPLAS_TO_MAIN_SEGUE = "SplashToMainSegue"
        static let SPLAS_TO_LOGIN_SEGUE = "SplashToLoginSegue"
        static let LOGIN_TO_MAIN_SEGUE = "LoginToMainSeguea"
        static let ADICON_TO_AVERTISER_PROFILE_SEGUE = "AdIconToAdvertiserProfile"
        static let HOME_TOVIDEO_AD_DETAILS_SEGUE = "HomeToVideoDetails"
        static let HOME_TO_FLYER_LIST_SEGUE = "HomeToFlyerListSegue"
        static let VIDEO_DETAILS_TO_WEBVIEW_SEGUE = "VideoDetailsToWebView"
        static let HOME_TO_ADS_BY_CATEGORY_SEGUE = "HomeToAdsByCategorySegue"
        static let HOME_TO_REGULAR_AD_DETAILS_SEGUE = "HomeToRegularAdDetailsSegue"
        static let REGULAR_AD_DETAILS_TO_WEBVIEW_SEGUE = "RegularAdDtailsToWebView"
        static let MY_COUPONS_TO_REGULAR_SEGUE = "MyCouponsToRegularSegue"
        static let MY_COUPONS_TO_VIDEO_SEGUE = "MyCouponsToVideoSegue"
        static let REGULAR_AD_TO_REDEEM_COUPON_SEGUE = "RegularAdToRedeemCoupon"
        static let VIDEO_AD_REDEEM_COUPON_SEGUE = "MyCouponsToVideoSegue"
        static let MAP_TO_MULTI_AD_LIST_SEGUE = "MapToMultiAdList"
        static let MAP_TO_REGUALR_AD_SEGUE = "MpToRegularAdSegue"
        static let HOME_TO_STORY_VIEWER_SEGUE = "HomeToStoryViewer"
        static let WALKTHOUGH_TO_MAIN_SEGUE = "WalkthroughToMain"
        static let LOGIN_TO_INTRESTS_SEGUE = "LoginToIntrestsSegue"
        static let MAINTAB_TO_SEARCH_SEGUE = "MainTabToSearchSegue"
    }
    
    public class CellsIDs{
        //Common Cells idnitifiers
        static let STACKOVERFLOW_POSTS_CELL = "stackoverflow_posts_cell"
        static let ADS_LIST_CELL = "AdsListCell"
        static let FLYER_LIST_CELL = "FlyerListTableViewCell"
        static let PROFILE_LIST_CELL = "ProfileListTableViewCell"
        static let INTRESTS_LIST_CELL = "IntrestsUICollectionViewCell"
        static let HOME_PAGE_CELL = "HomePageTableViewCell"
        static let HOME_PAGE_ITEM_CELL = "HomePageItemCollectionViewCell"
        static let HOME_PAGE_FOOTER_CELL = "HomePageFooterCollectionReusableView"
        static let MY_COUPONS_CELL = "MyCouponTableViewCell"
        static let ADS_BY_CATEGORY_CELL = "AdsByCategoryTableViewCell"
        static let MY_NOTIFICATIONS_CELL = "MyNotificationsTableViewCell"
        static let MY_COUPONS_COLLECTIONVIEW_CELL = "MyCouponsCell"
        static let MULTI_AD_LIST_CELL = "MultiAdListTableViewCell"
        static let STORIES_CELL = "StoriesCollectionViewCell"
        static let HOME_STORY_HEADER_CELL = "HomeStoryHeaderTableViewCell"
        static let HOME_SECOND_ROW_HOT_DEAL_CELL = "HomeSecondRowTableViewCell"
        static let HOME_HOT_DEAL_CELL = "HomeHotDealItemCollectionViewCell"
        static let NEARBY_ADS_HORIZONTAL_CELL = "NearbyAdsHorizontalCollectionViewCell"
        static let FAVORITE_ADS_TABLE_CELL = "FavoriteAdsTableViewCell"
        static let BRANDS_COLLECTIONVIEW_CELL = "BrandsCollectionViewCell"
        static let GOOGLE_PLACES_TABLEVIEW_CELL = "GooglePlacesTableViewCell"
        static let RECENT_SEARCHES_TABLEVIEW_CELL = "RecentSearchesTableViewCell"
    }
    
    public class AppCenter{
        
        static let APP_CENTER_APP_ID = "04f3d897-07bb-4c59-84b0-7cc8299a94de"
        
        //App Center Insight Consnats
        static let APP_CENTER_CATEGORY_TRACE = "trace"
        static let APP_CENTER_CATEGORY_BUSINESS = "business"
        static let APP_CENTER_CATEGORY_PAGE_VIEW = "page_view"
        
        //Track Event Keys
        static let APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED = "fragmentName"
        static let APP_CENTER_EVENT_KEY_FLYER_CLICKED = "flayerClicked"
        static let APP_CENTER_EVENT_KEY_SLICE_CART_CLICKED = "sliceCartClicked"
        static let APP_CENTER_EVENT_KEY_SLICE_CLIPPED = "sliceClipped"
        static let APP_CENTER_EVENT_KEY_SLICE_UNCLIPPED = "sliceUnClipped"
        static let APP_CENTER_EVENT_KEY_REQUEST_START_TIME = "requestStartTime"
        static let APP_CENTER_EVENT_KEY_REQUEST_END_TIME = "requestEndTime"
        static let APP_CENTER_EVENT_KEY_LANGUAGE_CHANGED = "languageChangedTo"
        static let APP_CENTER_EVENT_KEY_METHOD_NAME = "mathodeName"
        static let APP_CENTER_EVENT_KEY_MAP_AD_CLICKED = "mapADClicked"
        static let APP_CENTER_EVENT_KEY_MAP_AD_DETAILS_CLICKED = "mapAdDetailsCLicked"
    }
    
}
