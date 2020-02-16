//
//  AppDelegate.swift
//  MVVM Alamofire
//
//  Created by Business Intelligence For Technology on 7/12/18.
//  Copyright © 2018 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import RealmSwift
import MSAL
import Firebase
import UserNotifications
import GoogleMaps
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import MOLH
import NotificationBannerSwift
import SwiftRater
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var configValues: NSDictionary?
    var notificationHubNamespace : String?
    var notificationHubName : String?
    var notificationHubKeyName : String?
    var notificationHubKey : String?
    let tags = ["12345"]
    let genericTemplate = PushTemplate(withBody: "{\"aps\":{\"alert\":\"$(message)\"}}")//{\"aps\":\"$(message)\"")
    var registrationService : NotificationRegistrationService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        MOLHLanguage.setDefaultLanguage("ar-001")
        MOLHLanguage.setDefaultLanguage("en")
        MOLH.shared.activate(true)
        
        setupAppRate()
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey(Constants.Common.GOOGLE_MAP_API_KEY)
        GMSPlacesClient.provideAPIKey(Constants.Common.GOOGLE_PLACES_API_KEY)
        
        setupAzureNotificationsHub(application: application)
        
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                // Any migration logic older Realm files may need
        })
        
        Realm.Configuration.defaultConfiguration = config

        MSALGlobalConfig.loggerConfig.setLogCallback { (logLevel, message, containsPII) in
                   
                   if (!containsPII) {
                       
                       print("%@", message!)
                       
                   }
               }
        
        MSAppCenter.start(Constants.AppCenter.APP_CENTER_APP_ID, withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        
        return true
    }
    
    func setupAppRate() {
        SwiftRater.daysUntilPrompt = 7
        SwiftRater.usesUntilPrompt = 10
        SwiftRater.significantUsesUntilPrompt = 3
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = false
        SwiftRater.appLaunched()
    }
    
    func setupAzureNotificationsHub(application: UIApplication) {
        if let path = Bundle.main.path(forResource: "devsettings", ofType: "plist") {
            if let configValues = NSDictionary(contentsOfFile: path) {
                self.notificationHubNamespace = configValues["notificationHubNamespace"] as? String
                self.notificationHubName = configValues["notificationHubName"] as? String
                self.notificationHubKeyName = configValues["notificationHubKeyName"] as? String
                self.notificationHubKey = configValues["notificationHubKey"] as? String
            }
        }

        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in

                if (granted)
                {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installationId = (UIDevice.current.identifierForVendor?.description)!
        let pushChannel = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        // Initialize the Notification Registration Service
        self.registrationService = NotificationRegistrationService(
            withInstallationId: installationId,
            andPushChannel: pushChannel,
            andHubNamespace: notificationHubNamespace!,
            andHubName: notificationHubName!,
            andKeyName: notificationHubKeyName!,
            andKey: notificationHubKey!)

        // Call register, passing in the tags and template parameters
        self.registrationService!.register(withTags: tags, andTemplates: ["genericTemplate" : self.genericTemplate]) { (result) in
            if !result {
                print("Registration issue")
            } else {
                print("Registered")
            }
        }
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("KhaledResponse: \(notification.request.content.body)")
        if let recievedData = notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary,
            let dataPayload = recievedData["data"] as? NSDictionary {

            let titleEn = dataPayload["titleEn"] as! String
            let messageEn = dataPayload["messageEn"] as! String
            let titleAr = dataPayload["titleAr"] as! String
            let messageAr = dataPayload["messageAr"] as! String

            if MOLHLanguage.currentAppleLanguage() == "ar" {
                showNotifications(title: titleAr, message: messageAr)
            }else{
                showNotifications(title: titleEn, message: messageEn)
            }
            print("Message: \(notification.request.content.body)")
        }
        
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Message: \(response.notification.request.content.body)")
    }

    func showNotifications(title : String, message: String) {
        let banner = FloatingNotificationBanner(title: title, subtitle: message, style: .info)
        
        let bannerQueueToDisplaySeveralBanners = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
        
        banner.show(bannerPosition: BannerPosition(rawValue: 1)!,
        queue: bannerQueueToDisplaySeveralBanners,
        cornerRadius: 8,
        shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
        shadowBlurRadius: 16,
        shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
        
        banner.onTap = {
            //TODO: take action
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print("Received callback!")
        
        guard let sourceApp = sourceApplication else { return false }
        
        MSALPublicClientApplication.handleMSALResponse(url, sourceApplication: sourceApp)
        
        return true
    }


}

