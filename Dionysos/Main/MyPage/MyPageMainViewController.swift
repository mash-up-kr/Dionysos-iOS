//
//  MyPageMainViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class MyPageMainViewController: UIViewController {
    @IBOutlet private weak var statisticCollectionView: UICollectionView!
    @IBOutlet private weak var timeStampCollectionView: UICollectionView!
    @IBOutlet private weak var statistic: UIButton!
    @IBOutlet private weak var timeStamp: UIButton!
    @IBOutlet private weak var statisticLineView: UIView!
    @IBOutlet private weak var timeStampLineView: UIView!
    
    @IBAction private func staticsButtonAction(_ sender: Any) {
        statistic.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        timeStamp.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        statisticCollectionView.isHidden = false
        timeStampCollectionView.isHidden = true
        
        statisticLineView.isHidden = false
        timeStampLineView.isHidden = true
    }
    @IBAction private func timeStampButtonAction(_ sender: Any) {
        statistic.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        timeStamp.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        
        statisticCollectionView.isHidden = true
        timeStampCollectionView.isHidden = false
        
        statisticLineView.isHidden = true
        timeStampLineView.isHidden = false
    }
    
    private var isStatistic: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        staticsButtonAction(UIButton())
        view.addSubview(MainTabCenter.default.getMainTab())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(MainTabCenter.default.getMainTab())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MyPageMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == statisticCollectionView {
            return 30
        }
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == statisticCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatiticsCalendarCollectionViewCell", for: indexPath) as! StatiticsCalendarCollectionViewCell
            cell.setFrequency(.none)
            
            let num = indexPath.row % 5
            if num == 0 {
                cell.setFrequency(.none)
            } else if num == 1 {
                cell.setFrequency(.less)
            } else if num == 2 {
                cell.setFrequency(.normal)
            } else if num == 3 {
                cell.setFrequency(.more)
            } else if num == 4 {
                cell.setFrequency(.most)
            }
            
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageFeedCollectionViewCell", for: indexPath)
    }
}

extension MyPageMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == statisticCollectionView {
            let width: CGFloat = ((UIApplication.shared.currentWindow?.frame.width ?? 0) - 64) / 7.0
            return CGSize(width: width, height: width)
        }
        let width: CGFloat = ((UIApplication.shared.currentWindow?.frame.width ?? 0) - (23 * 2)) / 3.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == statisticCollectionView {
            return 4
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == statisticCollectionView {
            return 4
        }
        return 2
    }
}
