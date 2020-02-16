//
//  AzureMapViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 10/30/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import WebKit
import AppCenterAnalytics
import AppCenterCrashes


class AzureMapViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        webView.configuration.preferences.javaScriptEnabled = true
        webView.configuration.userContentController.add(self, name: "clipSlice")
        webView.configuration.userContentController.add(LogContentHandler(), name: "log")
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        let url = Bundle.main.url(forResource: "azure_maps", withExtension: "html", subdirectory: "azure_map_files")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "AzureMapViewController"])
    }
    
    func sendMessageToJS(msg: String){
        
        let js = "showTestLog(\"\(msg)\");"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
}


extension AzureMapViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("\(message.body) clipped slice")
        
        
    }
    
    
}
