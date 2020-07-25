//
//  SceneDelegate.swift
//  Dionysos
//
//  Created by Jercy on 2020/05/19.
//  Copyright © 2020 Mashup. All rights reserved.
//

import FacebookCore
import FacebookLogin
import KakaoOpenSDK
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        KOSession.handleOpen(url)
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window: UIWindow = UIWindow(windowScene: scene)

        if UserDefaults.standard.string(forKey: "myToken") == nil {
            window.rootViewController = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateInitialViewController()
        } else {
            window.rootViewController = MainTabCenter.default.getCurrentViewController()
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        logger(scene)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        logger(scene)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        KOSession.handleDidBecomeActive()
        logger(scene)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        logger(scene)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        KOSession.handleDidEnterBackground()
        logger(scene)
    }
}
