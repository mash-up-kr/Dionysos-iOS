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
        
        let fbLoginButton: FBLoginButton = FBLoginButton()
        fbLoginButton.center = view.center
        view.addSubview(fbLoginButton)
        
        let kakaoLoginButton: KOLoginButton = KOLoginButton(
            frame: CGRect(origin: .zero, size: fbLoginButton.bounds.size)
        )
        kakaoLoginButton.center = view.center
        view.addSubview(kakaoLoginButton)
        kakaoLoginButton.addTarget(self, action: #selector(kakaoButtonDidTap), for: .touchUpInside)
        
        let appleLoginButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        appleLoginButton.addTarget(self, action: #selector(handleAppleSignInButton), for: .touchUpInside)
        appleLoginButton.center = view.center
        view.addSubview(appleLoginButton)
        
        initializedLogin()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func kakaoButtonDidTap() {
        Promise.start {
            KakaoAuth.login()
        }.then {
            KakaoAuth.getToken()
        }.then {
            logger($0)
        }.catch {
            logger($0.localizedDescription)
        }
    }
}

extension ViewController {
    private func initializedLogin() {
        let loginManager: LoginManager = LoginManager()
        loginManager.logOut()
        addNotificationForFaceBookLogin()
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
    
    @objc
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
        guard let token: Data = credential.identityToken else { return }
        logger(token)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 에러")
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
