//
//  MainTab.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

enum MainTabType {
    case ranking
    case home
    case myPage
}

final class MainTab: UIView {
    private lazy var homeButton: UIButton = {
        let button: UIButton = UIButton()
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.setImage(UIImage(named: "buttonHomeOff"), for: .normal)
        button.setImage(UIImage(named: "btnTabHomeOn72Px"), for: .selected)
        button.addTarget(self, action: #selector(homeButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var myPageButton: UIButton = {
        let button: UIButton = UIButton()
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: homeButton.centerXAnchor, constant: 84).isActive = true
        button.setImage(UIImage(named: "btnTabMyOff64Px"), for: .normal)
        button.setImage(UIImage(named: "btnMyOn72Px1"), for: .selected)
        button.addTarget(self, action: #selector(myPageButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var rankingButton: UIButton = {
        let button: UIButton = UIButton()
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: homeButton.centerXAnchor, constant: -84).isActive = true
        button.setImage(UIImage(named: "btnTabRankingOff64Px"), for: .normal)
        button.setImage(UIImage(named: "buttonRankingOn72Px"), for: .selected)
        button.addTarget(self, action: #selector(rankingButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func rankingButtonAction(_ sender: Any) {
        changeTab(.ranking)
    }
    @objc
    private func homeButtonAction(_ sender: Any) {
        changeTab(.home)
    }
    @objc
    private func myPageButtonAction(_ sender: Any) {
        changeTab(.myPage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        switch MainTabCenter.default.getCurrentTab() {
        case .home:
            setHome()
        case .ranking:
            setRanking()
        case .myPage:
            setMyPage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        switch MainTabCenter.default.getCurrentTab() {
        case .home:
            setHome()
        case .ranking:
            setRanking()
        case .myPage:
            setMyPage()
        }
    }
}

extension MainTab {
    func changeSelectedButtonToCurrentType() {
        changeButtonSelected(MainTabCenter.default.getCurrentTab())
    }
    
    private func changeTab(_ selectedTab: MainTabType) {
        switch selectedTab {
        case .home:
            setHome()
        case .ranking:
            setRanking()
        case .myPage:
            setMyPage()
        }
    }
    
    private func setHome() {
        MainTabCenter.default.setCurrentTab(.home)
        changeViewController()
        changeButtonSelected(.home)
    }
    
    private func setRanking() {
        MainTabCenter.default.setCurrentTab(.ranking)
        changeViewController()
        changeButtonSelected(.ranking)
    }
    
    private func setMyPage() {
        MainTabCenter.default.setCurrentTab(.myPage)
        changeViewController()
        changeButtonSelected(.myPage)
    }
    
    private func changeButtonSelected(_ type: MainTabType) {
        homeButton.isSelected = false
        rankingButton.isSelected = false
        myPageButton.isSelected = false
        
        let selectedButton: UIButton?
        switch type {
        case .home:
            selectedButton = homeButton
        case .myPage:
            selectedButton = myPageButton
        case .ranking:
            selectedButton = rankingButton
        }
        
        selectedButton?.isSelected = true
        selectedButton?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.35,
                       initialSpringVelocity: 0.8,
                       options: [.allowUserInteraction, .curveEaseInOut],
                       animations: {
                        selectedButton?.transform = CGAffineTransform.identity
        })
    }
    
    private func changeViewController() {
        MainTabCenter.showCurrentViewController()
    }
}
