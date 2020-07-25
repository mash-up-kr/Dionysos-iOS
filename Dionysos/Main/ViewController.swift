//
//  ViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/05/19.
//  Copyright © 2020 Mashup. All rights reserved.
//

import AuthenticationServices
import FacebookLogin
import KakaoOpenSDK
import Promises
import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializedLogin()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController {
    private func initializedLogin() {
        let loginManager: LoginManager = LoginManager()
        loginManager.logOut()
        addNotificationForFaceBookLogin()
        
        KakaoAuth.logout()
    }
}

///Kakao Login
extension ViewController {
    func kakaoButtonDidTap() {
        Promise.start {
            KakaoAuth.login()
        }.then {
            KakaoAuth.getUID()
        }.then {
            SocialLoginHelper.apiCall(type: .kakao, UID: $0)
        }.catch {
            logger($0.localizedDescription)
        }
    }
}

///Facebook Login
extension ViewController {
    private func addNotificationForFaceBookLogin() {
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: .main) { notification in
            guard isChangeUser(notification) else { return }
            
            let useId: String? = AccessToken.current?.userID
            SocialLoginHelper.apiCall(type: .kakao, UID: useId)
        }
        
        func isChangeUser(_ notification: Notification) -> Bool {
            ((notification.userInfo?[AccessTokenDidChangeUserIDKey]) != nil) as Bool
        }
    }
}

///Apple Login
extension ViewController {
    func handleAppleSignInButton() {
        let request: ASAuthorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        let userId: String? = credential.user
        SocialLoginHelper.apiCall(type: .kakao, UID: userId)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        logger("애플 로그인 에러")
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
