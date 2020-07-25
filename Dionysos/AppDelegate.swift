//
//  AppDelegate.swift
//  Dionysos
//
//  Created by Jercy on 2020/05/19.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Firebase
import UIKit
import KakaoOpenSDK
#if DEBUG
import Gedatsu
#endif

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase Setting
        FirebaseApp.configure()
        
        // Pretty AutoLayout error console log https://github.com/bannzai/Gedatsu
        #if DEBUG
        Gedatsu.open()
        #endif
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
        return KOSession.handleOpen(url)
      }
      
      return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
        return KOSession.handleOpen(url)
      }
      return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}
