//
//  PrivacyViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/09/10.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit
import WebKit

final class PrivacyViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://mogakgong.flycricket.io/privacy.html")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
