//
//  SignInViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import AuthenticationServices
import FacebookLogin
import KakaoOpenSDK
import Promises
import UIKit

final class SignInViewController: UIViewController {
    
    @IBAction func kakaoSignInClicked(_ sender: Any) {
        kakaoButtonDidTap()
    }
    
    @IBAction func fbSignInClicked(_ sender: Any) {
        //fbButtonDidTap()
    }
    
    @IBAction func appleSignInClicked(_ sender: Any) {
        handleAppleSignInButton()
    }
    
    @IBAction func guestSignInClicked(_ sender: Any) {
        SocialLoginHelper.apiCall(type: .guest, UID: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializedLogin()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        self.present(vc, animated: true)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SignInViewController {
    private func initializedLogin() {
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logOut()
        addNotificationForFaceBookLogin()
        KakaoAuth.logout()
    }
}

///Kakao Login
extension SignInViewController {
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
extension SignInViewController {
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
extension SignInViewController {
    func handleAppleSignInButton() {
        let request: ASAuthorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        let userId: String? = credential.user
        SocialLoginHelper.apiCall(type: .apple, UID: userId)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        logger("애플 로그인 에러")
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
