//
//  SettingViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/26.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    enum Rows: Int, CaseIterable {
        case use
        case contact
        case madeby
        case version
        case logout
        
        func getTitle() -> String {
            switch self {
            case .use:
                return "이용약관"
            case .contact:
                return "문의하기"
            case .madeby:
                return "만든이"
            case .version:
                return "버전"
            case .logout:
                return "로그아웃"
            }
        }
        
        func getContent() -> String {
            switch self {
            case .madeby:
                return "Dionysos"
            case .version:
                return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            default:
                return ""
            }
        }
        
        func getViewController() -> UIViewController? {
            switch self {
            case .madeby:
                return UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "MadeByViewController")
            default:
                return nil
            }
        }
    }
    @IBOutlet private weak var closeButton: UIButton!
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Rows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell, let setting = Rows(rawValue: indexPath.row) else { return .init() }
        cell.setSettings(title: setting.getTitle(), content: setting.getContent())

        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let setting = Rows(rawValue: indexPath.row),
            let viewController = setting.getViewController() else { return }
        self.present(viewController, animated: true, completion: nil)
    }
}
