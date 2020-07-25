//
//  MainTabCenter.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class MainTabCenter {
    static var `default`: MainTabCenter = MainTabCenter()
    private var currentTab: MainTabType = .home
    private var homeViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() ?? UIViewController()
    private var rankingViewController: UIViewController = UIStoryboard(name: "Ranking", bundle: nil).instantiateInitialViewController() ?? UIViewController()
    private var myPageViewController: UIViewController = UIStoryboard(name: "MyPage", bundle: nil).instantiateInitialViewController() ?? UIViewController()
    private lazy var mainTab: UIView = MainTab(frame: .init(x: 0, y: UIScreen.main.bounds.height - 112, width: UIScreen.main.bounds.width, height: 112))
    
    func getMainTab() -> UIView {
        mainTab
    }
    
    func getCurrentTab() -> MainTabType {
        currentTab
    }
    
    func setCurrentTab(_ type: MainTabType) {
        currentTab = type
    }
    
    func getCurrentViewController() -> UIViewController {
        switch currentTab {
        case .home:
            return homeViewController
        case .myPage:
            return myPageViewController
        case .ranking:
            return rankingViewController
        }
    }
}
