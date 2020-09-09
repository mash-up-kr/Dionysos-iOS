//
//  PrivacyPolicyViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/08/18.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPrivacyPolicy()
    }
    
    func loadPrivacyPolicy() {
        let policyURL: URL? = URL(string: "https://mogakgong.flycricket.io/privacy.html")
        webView.load(URLRequest(url: policyURL!))
    }
}
