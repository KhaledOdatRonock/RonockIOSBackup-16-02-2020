//
//  FlyerViewerViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 10/20/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import WebKit
import NBBottomSheet
import AppCenterAnalytics
import AppCenterCrashes


public protocol MyProtocol: class {
    func unCLipNow(sliceID: UnClipSliceParams)
}

class FlyerViewerViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    let viewModel = FlyerViewerViewModel(repository: Repository.shared)
    var isSlicesShown = true;
    var flyerID: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.register(defaults: [
            Constants.SharedPreferencesKeys.PREFS_KEY_SHOULD_SLICES_SHOWN: true
        ])
        isSlicesShown = UserDefaults.standard.bool(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_SHOULD_SLICES_SHOWN)
        
        self.activityIndicatorStart()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        webView.configuration.preferences.javaScriptEnabled = true
        
        let clipSliceHandler = SliceClippedContentHandler()
        clipSliceHandler.flyerViewController = self
        webView.configuration.userContentController.add(clipSliceHandler , name: "clipSlice")
        
        let pageLoadedHandler = PageLoadingContentHandler()
        pageLoadedHandler.viewController = self
        webView.configuration.userContentController.add(pageLoadedHandler, name: "pageLoaded")
        
        let unclippSliceHandler = SliceUnClippedContentHandler()
        unclippSliceHandler.flyerViewController = self
        webView.configuration.userContentController.add(unclippSliceHandler, name: "unclipSlice")
        
        webView.configuration.userContentController.add(LogContentHandler(), name: "log")
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        let url = Bundle.main.url(forResource: "flyer-viewer", withExtension: "html", subdirectory: "flyer_final")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
        
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error.localizedDescription)
            }
        }
        
        viewModel.didFinishFetch = { sliceClippedResponse in
            print(sliceClippedResponse)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "FlyerViewerViewController"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityIndicatorStop()
    }
    
    func initFlyer(catalogID: String){
        let js = "initFlyer(\"\(UserDefaults.standard.string(forKey: Constants.SharedPreferencesKeys.PREFS_KEY_ACCESS_TOKEN) ?? "")\",\"\(catalogID)\",\(isSlicesShown));"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func sendMessageToJS(msg: String){
        
        let js = "showTestLog(\"\(msg)\");"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func sliceClipped(sliceID: String) {
        
        print(sliceID)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        initFlyer(catalogID: flyerID ?? "")
    }
    
    func toggleSlicesShown(){
        var js = ""
        if isSlicesShown {
            js = "clearFlashSlices();"
        }else{
            js = "flashSlices();"
        }
        
        webView.evaluateJavaScript(js, completionHandler: nil)
        isSlicesShown = !isSlicesShown
        UserDefaults.standard.set(isSlicesShown, forKey: Constants.SharedPreferencesKeys.PREFS_KEY_SHOULD_SLICES_SHOWN)
    }
    
    @IBAction func toggleSlicesPressed(_ sender: Any) {
        toggleSlicesShown()
    }
    
}

class SliceClippedContentHandler: BaseWKScriptMessageHandler {
    var flyerViewController: FlyerViewerViewController?
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let jsonData = (message.body as? String)?.data(using: .utf8) else { return }
        let paramsObj = try! JSONDecoder().decode(ClippedSliceParams.self, from: jsonData)
        let unClippItem = UnClipSliceParams(advertiserID: paramsObj.advertiserID, sliceID: paramsObj.sliceID)
        
        let configuration = NBBottomSheetConfiguration(animationDuration: 0.4, sheetSize: .fixed((flyerViewController?.view.bounds.height ?? 0)/2), backgroundViewColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))

        let bottomSheetController = NBBottomSheetController(configuration: configuration)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bottomSheetVC") as! BottomSheetViewController
        viewController.dele = flyerViewController
        viewController.selectedSliceID = unClippItem
        
        flyerViewController?.viewModel.clipSLice(clipped: paramsObj)
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_SLICE_CLIPPED: "\(message.body as? String) success clipped"])
        print("\(message.body) clipped slice")
        
        bottomSheetController.present(viewController, on: flyerViewController!)
        
        
        
        
    }
}
class SliceUnClippedContentHandler: BaseWKScriptMessageHandler {
    var flyerViewController: FlyerViewerViewController?
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let jsonData = (message.body as? String)?.data(using: .utf8) else { return }
        let paramsObj = try! JSONDecoder().decode(UnClipSliceParams.self, from: jsonData)
        
        flyerViewController?.viewModel.unClipSLice(unclipped: paramsObj)
    }
}

extension FlyerViewerViewController: MyProtocol{
    
    func unCLipNow(sliceID: UnClipSliceParams) {
        let js = "unclip(\"\(sliceID.sliceID)\");"
        webView.evaluateJavaScript(js, completionHandler: nil)
        
        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_BUSINESS, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_SLICE_UNCLIPPED: "\(sliceID) success unclipped"])
        viewModel.unClipSLice(unclipped: sliceID)
        
    }
    
}
class PageLoadingContentHandler: BaseWKScriptMessageHandler {
    var viewController: BaseViewController?
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        viewController?.activityIndicatorStop()
    }
}
class LogContentHandler: BaseWKScriptMessageHandler {
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("\(message.body)")
    }
}
