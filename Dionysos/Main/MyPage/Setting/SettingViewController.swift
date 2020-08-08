//
//  SettingViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/26.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet private weak var closeButton: UIButton!
    private var settingTitles: [String] = ["이용약관", "문의하기", "만든이", "버전", "로그아웃"]
    private var settingContents: [String: String] = [
        "만든이": "Dionysos",
        "버전": UIDevice.current.systemVersion
    ]
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { return .init() }
        let settingTitle: String = settingTitles[indexPath.row]
        cell.setSettings(title: settingTitle, content: settingContents[settingTitle])
        
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
}
