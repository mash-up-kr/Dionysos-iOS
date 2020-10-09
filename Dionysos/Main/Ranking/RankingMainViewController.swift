//
//  RankingMainViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class RankingMainViewController: UIViewController {
    enum RankingTap {
        case day
        case week
        case month
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = .init(top: 0, left: 0, bottom: 120, right: 0)
        }
    }
    @IBOutlet private weak var firstProfile: UIImageView!
    @IBOutlet private weak var firstUserName: UILabel!
    @IBOutlet private weak var firstDuration: UILabel!
    @IBOutlet private weak var secondProfile: UIImageView!
    @IBOutlet private weak var secondUserName: UILabel!
    @IBOutlet private weak var secondDuration: UILabel!
    @IBOutlet private weak var thirdProfile: UIImageView!
    @IBOutlet private weak var thirdUserName: UILabel!
    @IBOutlet private weak var thirdDuration: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var weekLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var blackViewCenterConstraint: NSLayoutConstraint!
    @IBAction private func dayButtonAction(_ sender: Any) {
        moveTabButton(-95)
        callApi(tap: .day)
        dayLabel.textColor = UIColor(named: "basicWhite")
        weekLabel.textColor = UIColor(named: "darkGrey")
        monthLabel.textColor = UIColor(named: "darkGrey")
    }
    @IBAction private func weekButtonAction(_ sender: Any) {
        moveTabButton(0)
        callApi(tap: .week)
        dayLabel.textColor = UIColor(named: "darkGrey")
        weekLabel.textColor = UIColor(named: "basicWhite")
        monthLabel.textColor = UIColor(named: "darkGrey")
    }
    @IBAction private func monthButtonAction(_ sender: Any) {
        moveTabButton(95)
        callApi(tap: .month)
        dayLabel.textColor = UIColor(named: "darkGrey")
        weekLabel.textColor = UIColor(named: "darkGrey")
        monthLabel.textColor = UIColor(named: "basicWhite")
    }
    
    private var rankingModel: RankingModel? {
        didSet {
            tableView.reloadData()
            reloadTopUser()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayLabel.textColor = UIColor(named: "darkGrey")
        weekLabel.textColor = UIColor(named: "basicWhite")
        monthLabel.textColor = UIColor(named: "darkGrey")
        
        callApi(tap: .week)
        view.addSubview(MainTabCenter.default.getMainTab())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(MainTabCenter.default.getMainTab())
    }
    
    private func reloadTopUser() {
        guard let rankingModel = rankingModel else { return }
        if let first: EachRankingModel = rankingModel[safe: 0] {
            let timeAmount: TimeAmount = TimeAmount(TimeInterval(first.duration))
            firstDuration.text = String(format: "%02d:%02d:%02d", timeAmount.hours, timeAmount.minutes, timeAmount.seconds)
            firstUserName.text = first.nickname
        }
        if let second: EachRankingModel = rankingModel[safe: 1] {
            let timeAmount: TimeAmount = TimeAmount(TimeInterval(second.duration))
            secondDuration.text = String(format: "%02d:%02d:%02d", timeAmount.hours, timeAmount.minutes, timeAmount.seconds)
            secondUserName.text = second.nickname
        }
        if let third: EachRankingModel = rankingModel[safe: 2] {
            let timeAmount: TimeAmount = TimeAmount(TimeInterval(third.duration))
            thirdDuration.text = String(format: "%02d:%02d:%02d", timeAmount.hours, timeAmount.minutes, timeAmount.seconds)
            thirdUserName.text = third.nickname
        }
    }
    private func callApi(tap: RankingTap) {
        switch tap {
        case .month:
            DionysosProvider.getRankingMonth().then { [weak self] in
                self?.rankingModel = $0
            }
        case .day:
            DionysosProvider.getRankingDay().then { [weak self] in
                self?.rankingModel = $0
            }
        case .week:
            DionysosProvider.getRankingWeek().then { [weak self] in
                self?.rankingModel = $0
            }
        }
    }
}

extension RankingMainViewController {
    func moveTabButton(_ constant: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            self?.blackViewCenterConstraint.constant = constant
            self?.view.layoutIfNeeded()
        })
    }
}

extension RankingMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (rankingModel?.count ?? 0) - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rankIndex = indexPath.row + 3
        guard let user = rankingModel?[safe: rankIndex] else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRankingTableViewCell", for: indexPath) as! MyRankingTableViewCell
            cell.rankLabel.text = "\(rankIndex + 1)위"
            cell.nameLabel.text = user.nickname
            cell.durationLabel.text = TimeAmount(TimeInterval(user.duration)).description
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath) as! RankingTableViewCell
            cell.rankLabel.text = "\(rankIndex + 1)위"
            cell.nameLabel.text = user.nickname
            cell.durationLabel.text = TimeAmount(TimeInterval(user.duration)).description
            return cell
        }
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        // iOS 9 or later
        return indices ~= index ? self[index] : nil
        // iOS 8 or earlier
        // return startIndex <= index && index < endIndex ? self[index] : nil
        // return 0 <= index && index < self.count ? self[index] : nil
    }
}
