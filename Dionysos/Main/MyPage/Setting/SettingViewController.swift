//
//  SettingViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/26.
//  Copyright © 2020 Mashup. All rights reserved.
//

import MessageUI
import Moya
import UIKit

final class SettingViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    @IBAction private func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        func doNext(current: UINavigationController) {
            guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
            
            let viewController: UIViewController?
            switch self {
            case .madeby:
                viewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "MadeByViewController")
            case .use:
                viewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "PrivacyPolicyViewController")
            case .logout:
                let logoutAlert: UIAlertController = UIAlertController(title: "안내", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
                let logoutAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { _ in
                    guard let token = UserDefaults.standard.string(forKey: "myToken") else { return }
                    
                    DionysosProvider.callSignOut(token: token).then { _ in
                        MainTabCenter.showCurrentViewController()
                    }.catch {
                        guard let error = $0 as? Moya.MoyaError else { return }
                        logger(error)
                    }
                })
                logoutAlert.addAction(cancelAction)
                logoutAlert.addAction(logoutAction)
                
                viewController = logoutAlert
            default:
                viewController = nil
            }
            guard let tobePresented = viewController else { return }
            //guard let root = window.rootViewController as? UINavigationController else { return }
            current.pushViewController(tobePresented, animated: true)
            
//            window.rootViewController?.presentedViewController?.present(tobePresented, animated: true, completion: nil)
        }
    }
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
        guard let setting = Rows(rawValue: indexPath.row) else { return }
        switch setting {
        case .contact:
            sendEmail()
        default:
            setting.doNext(current: self.navigationController!)
        }
    }
}

extension SettingViewController {
    private func sendEmail() {
        func createEmailUrl(to: String, subject: String, body: String) -> URL? {
            let subjectEncoded: String = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let bodyEncoded: String = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

            let gmailUrl: URL? = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let outlookUrl: URL? = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
            let yahooMail: URL? = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let sparkUrl: URL? = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let defaultUrl: URL? = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

            if let gmailUrl: URL = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                return gmailUrl
            } else if let outlookUrl: URL = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                return outlookUrl
            } else if let yahooMail: URL = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                return yahooMail
            } else if let sparkUrl: URL = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                return sparkUrl
            }

            return defaultUrl
        }
        
        let recipientEmail: [String] = ["kaskay77@gmail.com"]
        let subject: String = "Mogakgong Contact"
        let body: String = """
        \n\n\n\n
        :::::::::::::::::::::::::::::::::::::::::::::::::
        App Name : "Mogakgong"
        App Version : \(UIApplication.appVersion ?? "")
        Device : \(UIDevice().type)
        OS : \(UIDevice.current.systemVersion)
        :::::::::::::::::::::::::::::::::::::::::::::::::
        """
        
        if MFMailComposeViewController.canSendMail() {
            let mailController: MFMailComposeViewController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(recipientEmail)
            mailController.setSubject(subject)
            mailController.setMessageBody(body, isHTML: false)

            present(mailController, animated: true)
        } else if let emailUrl: URL = createEmailUrl(to: recipientEmail.first!, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
