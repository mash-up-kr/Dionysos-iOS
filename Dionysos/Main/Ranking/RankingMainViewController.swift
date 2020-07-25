//
//  RankingMainViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class RankingMainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = .init(top: 0, left: 0, bottom: 120, right: 0)
        }
    }
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var weekLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var blackViewCenterConstraint: NSLayoutConstraint!
    @IBAction private func dayButtonAction(_ sender: Any) {
        moveTabButton(-95)
        dayLabel.textColor = UIColor(named: "white")
        weekLabel.textColor = UIColor(named: "darkGrey")
        monthLabel.textColor = UIColor(named: "darkGrey")
    }
    @IBAction private func weekButtonAction(_ sender: Any) {
        moveTabButton(0)
        dayLabel.textColor = UIColor(named: "darkGrey")
        weekLabel.textColor = UIColor(named: "white")
        monthLabel.textColor = UIColor(named: "darkGrey")
    }
    @IBAction private func monthButtonAction(_ sender: Any) {
        moveTabButton(95)
        dayLabel.textColor = UIColor(named: "darkGrey")
        weekLabel.textColor = UIColor(named: "darkGrey")
        monthLabel.textColor = UIColor(named: "white")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayLabel.textColor = UIColor(named: "darkGrey")
        weekLabel.textColor = UIColor(named: "white")
        monthLabel.textColor = UIColor(named: "darkGrey")
        
        view.addSubview(MainTabCenter.default.getMainTab())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(MainTabCenter.default.getMainTab())
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRankingTableViewCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath)
        return cell
    }
}
