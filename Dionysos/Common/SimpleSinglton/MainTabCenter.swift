//
//  MainTabCenter.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

struct MainTabCenter {
    static var `default`: MainTabCenter = MainTabCenter()
    private var currentTab: MainTabType = .home
    
    func getCurrentTab() -> MainTabType {
        currentTab
    }
    
    mutating func setCurrentTab(_ type: MainTabType) {
        currentTab = type
    }
}
