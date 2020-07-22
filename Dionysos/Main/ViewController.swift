//
//  ViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/05/19.
//  Copyright © 2020 Mashup. All rights reserved.
//

import FacebookLogin
import UIKit

final class ViewController: UIViewController {
     override func viewDidLoad() {
          super.viewDidLoad()
          
          let fbLoginButton: FBLoginButton = FBLoginButton()
          fbLoginButton.center = view.center
          view.addSubview(fbLoginButton)
          
          addNotificationForFaceBookLogin()
     }
     
     deinit {
          NotificationCenter.default.removeObserver(self)
     }
}

extension ViewController {
     private func addNotificationForFaceBookLogin() {
          NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: .main) { [weak self] notification in
               guard isChangeUser(notification) else { return }
               
               let token: String? = SocialLoginHelper.getToken(type: .facebook)
               logger(token)
          }
          
          func isChangeUser(_ notification: Notification) -> Bool {
               ((notification.userInfo?[AccessTokenDidChangeUserIDKey]) != nil) as Bool
          }
     }
}
