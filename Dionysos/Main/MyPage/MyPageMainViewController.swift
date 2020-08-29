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
    @IBOutlet private weak var pickerView: SmoothPickerView!
    var views: [UIView] = []
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

    private var index = 0
    private var previousView: PickerDataView?
    private var isStatistic: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        staticsButtonAction(UIButton())
        view.addSubview(MainTabCenter.default.getMainTab())
        
        for index in 0 ..< (12 * 10) {
            let view: PickerDataView = PickerDataView(index: index)
            views.append(view)
        }
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let nameOfMonth = dateFormatter.string(from: now)
        dateFormatter.dateFormat = "yyyy"
        let nameOfYear = dateFormatter.string(from: now)
        
        let index = (Int(nameOfMonth)! - 1) + (Int(nameOfYear)! - 2020)
        pickerView.firstselectedItem = index
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

extension MyPageMainViewController: SmoothPickerViewDataSource, SmoothPickerViewDelegate {
    func numberOfItems(pickerView: SmoothPickerView) -> Int {
        12 * 10
    }
    
    func itemForIndex(index: Int, pickerView: SmoothPickerView) -> UIView {
        views[index]
    }
    
    func didSelectItem(index: Int, view: UIView, pickerView: SmoothPickerView) {
        let pickerView = view as! PickerDataView
        previousView?.label.text = "\((view.tag % 12) + 1)"
        pickerView.label.text = "\((view.tag / 12) + 2020). \((view.tag % 12) + 1)"
        self.index = pickerView.tag
        previousView = pickerView
    }
}

class PickerDataView: UIView {
    let label: UILabel = UILabel()
    init(index: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
        
        tag = index
        addSubview(label)
        label.textColor = .black
        label.text = "\(index % 12 + 1)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
