//
//  WebViewViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/11/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController {

    var webURL: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let link = URL(string: webURL ?? "")!
        let request = URLRequest(url: link)
        webView.load(request)
        
        // Do any additional setup after loading the view.
    }
    

}
