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
import Moya
import Promises
import UIKit

enum SocialLoginType: String {
    case facebook = "FACEBOOK"
    case apple = "APPLE"
    case kakao = "KAKAO"
    case guest = "GUEST"
}

final class SignInViewController: UIViewController {
    @IBAction private func kakaoSignInClicked(_ sender: Any) {
        kakaoButtonDidTap()
    }
    
    @IBAction private func fbSignInClicked(_ sender: Any) {
        Promise.start {
            FacebookAuth.login()
        }.then { _ in
            FacebookAuth.getUID()
        }.then {
            logger($0)
        }.catch {
            logger($0)
        }
    }
    
    @IBAction private func appleSignInClicked(_ sender: Any) {
        handleAppleSignInButton()
    }
    
    @IBAction private func guestSignInClicked(_ sender: Any) {
        apiCall(type: .guest, UID: "")
//        SocialLoginHelper.apiCall(type: .guest, UID: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializedLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
//        self.present(vc, animated: true)
        
    }
    
    private func apiCall(type: SocialLoginType, UID: String?) {
        guard let token = UID else { return }
        
        if type == .guest {
            UIApplication.shared.currentWindow?.rootViewController = MainTabCenter.default.getCurrentViewController()
        }
        
        DionysosProvider.callSignIn(provider: type.rawValue, token: token).then { _ in
            UIApplication.shared.currentWindow?.rootViewController = MainTabCenter.default.getCurrentViewController()
        }.catch {
            guard let error = $0 as? Moya.MoyaError else { return }
            if error.response?.statusCode == 401 || error.response?.statusCode == 400 {
                guard let signUpVC = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateViewController(identifier: "NicknameInputViewController") as? NicknameInputViewController else { return }
                signUpVC.provider = type.rawValue
                signUpVC.token = token
                self.present(signUpVC, animated: true, completion: nil)
            }
        }
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
            self.apiCall(type: .kakao, UID: $0)
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
            
            guard let useId: String = AccessToken.current?.userID else { return }
            self.apiCall(type: .kakao, UID: useId)
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
        let userId: String = credential.user
        
        apiCall(type: .apple, UID: userId)
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
