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

class MainTab: UIView {
    var contentView: UIView?
    
    @IBOutlet private weak var rankingButton: UIButton!
    @IBOutlet private weak var homeButton: UIButton!
    @IBOutlet private weak var myPageButton: UIButton!
    
    @IBAction private func rankingButtonAction(_ sender: Any) {
        changeTab(.ranking)
    }
    @IBAction private func homeButtonAction(_ sender: Any) {
        changeTab(.home)
    }
    @IBAction private func myPageButtonAction(_ sender: Any) {
        changeTab(.myPage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.backgroundColor = .clear
        self.addSubview(view)
        contentView = view
        
        switch MainTabCenter.default.getCurrentTab() {
        case .home:
            setHome()
        case .ranking:
            setRanking()
        case .myPage:
            setMyPage()
        }
    }
    
    func loadViewFromNib() -> UIView? {
        let nib: UINib = UINib(nibName: "MainTab", bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

extension MainTab {
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
        homeButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.8, options: [], animations: { [weak self] in
            guard let self = self else { return }
            self.homeButton.transform = CGAffineTransform.identity
            self.homeButton.isSelected = true
        })
        rankingButton.isSelected = false
        myPageButton.isSelected = false
        
        MainTabCenter.default.setCurrentTab(.home)
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else { return }
        window?.rootViewController = vc
    }
    
    private func setRanking() {
        rankingButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.8, options: [], animations: { [weak self] in
            guard let self = self else { return }
            self.rankingButton.transform = CGAffineTransform.identity
            self.rankingButton.isSelected = true
        })
        homeButton.isSelected = false
        myPageButton.isSelected = false
        
        MainTabCenter.default.setCurrentTab(.ranking)
        
        guard let vc = UIStoryboard(name: "Ranking", bundle: nil).instantiateInitialViewController() else { return }
        window?.rootViewController = vc
    }
    
    private func setMyPage() {
        myPageButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.8, options: [], animations: { [weak self] in
            guard let self = self else { return }
            self.myPageButton.transform = CGAffineTransform.identity
            self.myPageButton.isSelected = true
        })
        homeButton.isSelected = false
        rankingButton.isSelected = false
        
        MainTabCenter.default.setCurrentTab(.myPage)
        
        guard let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateInitialViewController() else { return }
        window?.rootViewController = vc
    }
}
