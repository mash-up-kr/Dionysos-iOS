//
//  ViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/05/19.
//  Copyright © 2020 Mashup. All rights reserved.
//

import FacebookLogin
import KakaoOpenSDK
import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fbLoginButton: FBLoginButton = FBLoginButton()
        fbLoginButton.center = view.center
        view.addSubview(fbLoginButton)
        addNotificationForFaceBookLogin()
        
        let kakaoLoginButton = KOLoginButton(frame: CGRect(origin: .zero, size: fbLoginButton.bounds.size))
        kakaoLoginButton.center = view.center
        view.addSubview(kakaoLoginButton)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoButtonDidTap), for: .touchUpInside)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func kakaoButtonDidTap() {
        KakaoLogin.refreshSession().then {
            KakaoLogin.getToken()
        }.then {
            logger($0)
        }.catch {
            logger($0.localizedDescription)
        }
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
